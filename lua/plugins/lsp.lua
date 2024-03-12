return {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode, ---@diagnostic disable-line: undefined-field
    event = { "BufRead", "CmdlineEnter", "InsertEnter" },
    cmd = { "Mason" },
    keys = vim.g.vscode and {} or { ---@diagnostic disable-line: undefined-field
        { "<leader>m", "<cmd>Mason<cr>", desc = "Open Mason" },
    },
    dependencies = {
        "Hoffs/omnisharp-extended-lsp.nvim",
        "Issafalcon/lsp-overloads.nvim",
        "folke/neodev.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "jay-babu/mason-null-ls.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "joechrisellis/lsp-format-modifications.nvim",
        "jose-elias-alvarez/typescript.nvim",
        "kevinhwang91/nvim-ufo",
        "mfussenegger/nvim-dap",
        "nvim-lua/plenary.nvim",
        "nvimdev/lspsaga.nvim",
        "nvimtools/none-ls.nvim",
        "rcarriga/nvim-dap-ui",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        { "JulesNP/Ionide-vim", branch = "indent" },
    },
    init = function()
        -- Prevent auto setup of Ionide
        vim.g["fsharp#lsp_auto_setup"] = 0
        vim.g["fsharp#lsp_recommended_colorscheme"] = 0
    end,
    config = function()
        require("mason").setup {}
        local lspconfig = require "lspconfig"
        local mason_lsp = require "mason-lspconfig"
        mason_lsp.setup {}

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local lua_server_installed = vim.fn.executable "lua-language-server" == 1
        if lua_server_installed then
            require("neodev").setup {}
        end
        local function lua_setup()
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        hint = {
                            enable = true,
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                    },
                },
            }
        end

        mason_lsp.setup_handlers {
            function(server_name)
                lspconfig[server_name].setup { capabilities = capabilities }
            end,
            omnisharp = function()
                lspconfig.omnisharp.setup {
                    capabilities = capabilities,
                    handlers = { ["textDocument/definition"] = require("omnisharp_extended").handler },
                }
            end,
            fsautocomplete = function()
                vim.g["fsharp#external_autocomplete"] = 1
                vim.g["fsharp#simplify_name_analyzer"] = 1
                vim.g["fsharp#fsi_keymap"] = "custom"
                vim.g["fsharp#fsi_keymap_send"] = "<leader><cr>"
                vim.g["fsharp#fsi_keymap_toggle"] = "<m-\\>"
                vim.g["fsharp#lsp_codelens"] = 0

                require("ionide").setup {
                    autostart = true,
                    capabilities = capabilities,
                }
            end,
            lua_ls = lua_setup,
            tsserver = function()
                local inlay = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                }
                require("typescript").setup {
                    server = {
                        capabilities = capabilities,
                        settings = { typescript = { inlayHints = inlay }, javascript = { inlayHints = inlay } },
                    },
                }
            end,
        }
        -- Mason's install of lua-language-server doesn't work on Termux, so use globally installed version if available
        if not require("mason-registry").is_installed "lua-language-server" and lua_server_installed then
            lua_setup()
        end
        -- Set up ccls separately, since it isn't available through Mason
        if vim.fn.executable "ccls" == 1 then
            lspconfig.ccls.setup { capabilities = capabilities }
        end
        -- Check for local install of gleam, due to issues with Mason version
        if vim.fn.executable "gleam" == 1 then
            lspconfig.gleam.setup { capabilities = capabilities }
        end

        local null_ls = require "null-ls"
        local builtins = null_ls.builtins
        local sources = {
            builtins.code_actions.gitrebase,
            builtins.hover.dictionary,
            require "typescript.extensions.null-ls.code-actions",
        }
        local optional = {
            prettier = { builtins.formatting.prettier.with { extra_filetypes = { "pug" } } },
            stylua = { builtins.formatting.stylua },
        }
        for key, values in pairs(optional) do
            if not require("mason-registry").is_installed(key) and vim.fn.executable(key) == 1 then
                for _, value in ipairs(values) do
                    table.insert(sources, value)
                end
            end
        end
        null_ls.setup { diagnostics_format = "#{m} [#{s}]", sources = sources }

        require("mason-null-ls").setup { ---@diagnostic disable-line: missing-fields
            handlers = {
                function(source_name, methods)
                    require "mason-null-ls.automatic_setup"(source_name, methods)
                end,
                clang_format = function()
                    null_ls.register(builtins.formatting.clang_format.with { disabled_filetypes = { "cs" } })
                end,
                sqlfmt = function()
                    -- Custom config of sqlfmt using stdin, since base config only works with .sql files,
                    -- and Dadbod UI creates/saves queries without any extensions
                    null_ls.register {
                        name = "sqlfmt",
                        method = null_ls.methods.FORMATTING,
                        filetypes = { "jinja", "mysql", "sql" },
                        generator = require("null-ls.helpers").formatter_factory {
                            command = "sqlfmt",
                            args = { "-" },
                            to_stdin = true,
                        },
                    }
                end,
            },
        }

        require("dapui").setup()
        require("mason-nvim-dap").setup { ---@diagnostic disable-line: missing-fields
            handlers = {},
        }

        require("lspsaga").setup {
            ui = { border = "single" },
            diagnostic = { extend_relatedInformation = true },
            code_action = {
                show_server_name = true,
                only_in_cursor = false,
                keys = {
                    quit = { "<esc>", "q" },
                    exec = "<cr>",
                },
            },
            lightbulb = { virtual_text = false },
            finder = {
                keys = {
                    shuttle = "<c-w><c-w>",
                    toggle_or_open = "<cr>",
                    vsplit = "<c-v>",
                    split = "<c-s>",
                    tabe = "<c-t>",
                    tabnew = "<c-s-t>",
                    quit = "q",
                    close = "<c-q>",
                },
            },
            definition = {
                keys = {
                    edit = "<c-i>",
                    vsplit = "<c-v>",
                    split = "<c-s>",
                    tabe = "<c-t>",
                    tabnew = "<c-s-t>",
                    quit = "q",
                    close = { "<c-o>", "<c-q>" },
                },
            },
            symbol_in_winbar = { enable = false },
            outline = {
                layout = "float",
                max_height = 0.7,
                keys = {
                    toggle_or_jump = "<tab>",
                    quit = { "<c-q>", "q" },
                    jump = "<cr>",
                },
            },
            callhierarchy = {
                keys = {
                    edit = "<cr>",
                    vsplit = "<c-v>",
                    split = "<c-s>",
                    tabe = "<c-t>",
                    close = "<c-q>",
                    quit = "q",
                    shuttle = "<c-w><c-w>",
                    toggle_or_req = "<tab>",
                },
            },
            beacon = { enable = false },
        }

        local function sign(name, icon)
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end

        sign("DiagnosticSignHint", "󰌵")
        sign("DiagnosticSignInfo", "󰋼")
        sign("DiagnosticSignWarn", "")
        sign("DiagnosticSignError", "")

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(require "hover", {
            border = "single",
        })

        vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", { desc = "Next diagnostic" })
        vim.keymap.set("n", "<leader>i", vim.diagnostic.open_float, { desc = "View diagnostic info" })
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "List diagnostics" })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client.server_capabilities.completionProvider then
                    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
                end
                if client.server_capabilities.definitionProvider then
                    vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
                end

                local function opts(desc)
                    return { buffer = bufnr, desc = desc }
                end
                vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts "Signature help")
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.declaration, opts "Go to declaration")
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts "List workspace folders")
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts "Rename")
                vim.keymap.set("n", "K", function()
                    local peek = require("ufo").peekFoldedLinesUnderCursor()
                    if not peek then
                        vim.lsp.buf.hover()
                    end
                end, opts "Hover")
                vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts "Go to implementation")
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts "Go to references")
                vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts "Code action")
                vim.keymap.set("n", "<leader>lf", "<cmd>Lspsaga finder<cr>", opts "Find LSP references")
                vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<cr>", opts "LSP outline")

                if vim.bo.filetype ~= "cs" then
                    vim.keymap.set("n", "gD", "<cmd>Lspsaga peek_type_definition<cr>", opts "Go to type definition")
                    vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<cr>", opts "Go to definition")
                else -- omnisharp-specific settings
                    local function toSnakeCase(str)
                        return string.gsub(str, "%s*[- ]%s*", "_")
                    end
                    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
                    for i, v in ipairs(tokenModifiers) do
                        tokenModifiers[i] = toSnakeCase(v)
                    end
                    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
                    for i, v in ipairs(tokenTypes) do
                        tokenTypes[i] = toSnakeCase(v)
                    end
                    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts "Go to type definition")
                    vim.keymap.set("n", "gd", require("omnisharp_extended").lsp_definitions, opts "Go to definition")
                end

                vim.keymap.set("n", "<leader>bO", require("dap").step_out, opts "Step out")
                vim.keymap.set("n", "<leader>bb", require("dap").toggle_breakpoint, opts "Toggle breakpoint")
                vim.keymap.set("n", "<leader>bc", require("dap").continue, opts "Continue")
                vim.keymap.set("n", "<leader>bi", require("dap").step_into, opts "Step into")
                vim.keymap.set("n", "<leader>bo", require("dap").step_over, opts "Step over")
                vim.keymap.set("n", "<leader>bp", require("dap.ui.widgets").preview, opts "Preview value")
                vim.keymap.set("n", "<leader>bq", require("dap").list_breakpoints, opts "List breakpoints")
                vim.keymap.set("n", "<leader>bt", require("dapui").toggle, opts "Toggle debug UI")
                vim.keymap.set(
                    "n",
                    "<leader>bx",
                    require("dap").set_exception_breakpoints,
                    opts "Set exception breakpoints"
                )

                if client.supports_method "textDocument/formatting" then
                    local function format()
                        -- Only use LSP formatting if null-ls formatter is unavailable
                        local generators = require("null-ls.generators").get_available(
                            vim.bo.filetype,
                            require("null-ls.methods").FORMATTING
                        )

                        vim.lsp.buf.format {
                            async = false,
                            filter = function(fmt_client)
                                return #generators == 0 or fmt_client.name == "null-ls"
                            end,
                            timeout_ms = 2500,
                        }

                        vim.cmd "silent GuessIndent"
                    end
                    vim.keymap.set("n", "<c-s>", function()
                        vim.cmd.mkview()
                        format()
                        vim.cmd.update()
                    end, opts "Format and save if modified")
                    vim.keymap.set("n", "<leader>fm", format, opts "Format buffer")
                    if client.supports_method "textDocument/rangeFormatting" then
                        vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
                        require("lsp-format-modifications").attach(client, bufnr, {
                            format_callback = format,
                            format_on_save = false,
                            experimental_empty_line_handling = true,
                        })
                        vim.keymap.set("n", "<leader>fc", "<cmd>FormatModifications<cr>", opts "Format changes")
                    end
                end

                if client.server_capabilities.signatureHelpProvider then
                    require("lsp-overloads").setup(client, { ---@diagnostic disable-line: missing-fields
                        ui = { ---@diagnostic disable-line: missing-fields
                            border = "single",
                        },
                        keymaps = { ---@diagnostic disable-line: missing-fields
                            close_signature = "<m-x>",
                        },
                    })
                end
            end,
        })
    end,
}
