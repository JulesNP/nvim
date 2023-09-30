return {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    event = "BufRead",
    ft = { "dbui", "markdown" },
    cmd = { "Mason" },
    keys = vim.g.vscode and {} or {
        { "<leader>m", "<cmd>Mason<cr>", desc = "Open Mason" },
    },
    dependencies = {
        "Hoffs/omnisharp-extended-lsp.nvim",
        "Issafalcon/lsp-overloads.nvim",
        "folke/neodev.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        {
            "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
            config = function()
                local lsp_lines = require "lsp_lines"
                lsp_lines.setup()
                vim.diagnostic.config { virtual_text = false }
                vim.diagnostic.config({ virtual_lines = false }, require("lazy.core.config").ns)
                vim.keymap.set("n", "<leader>ti", lsp_lines.toggle, { desc = "Toggle LSP diagnostics" })
            end,
        },
        { "JulesNP/Ionide-vim", branch = "indent" },
        "jay-babu/mason-null-ls.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "joechrisellis/lsp-format-modifications.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        "jose-elias-alvarez/typescript.nvim",
        "kevinhwang91/nvim-ufo",
        "mfussenegger/nvim-dap",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "rcarriga/nvim-dap-ui",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
    },
    init = function()
        -- Prevent auto setup of Ionide
        vim.g["fsharp#lsp_auto_setup"] = 0
    end,
    config = function()
        vim.keymap.set("n", "<leader>i", vim.diagnostic.open_float, { desc = "View diagnostic info" })
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "List diagnostics" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

        local function sign(name, icon)
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end

        sign("DiagnosticSignHint", "󰌵")
        sign("DiagnosticSignInfo", "󰋼")
        sign("DiagnosticSignWarn", "")
        sign("DiagnosticSignError", "")

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "none",
        })
        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "none",
        })

        local function on_attach(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

            local telescope = require "telescope.builtin"
            local function nmap(key, func, desc)
                vim.keymap.set("n", key, func, { desc = desc, buffer = bufnr })
            end
            nmap("<leader>=", vim.lsp.codelens.refresh, "Refresh codelens")
            nmap("<leader>D", telescope.lsp_type_definitions, "Type definition")
            nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
            nmap("<leader>la", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
            nmap("<leader>lr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
            nmap("<leader>lw", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "List workspace folders")
            nmap("<leader>rn", vim.lsp.buf.rename, "Rename")
            nmap("K", function()
                local peek = require("ufo").peekFoldedLinesUnderCursor()
                if not peek then
                    vim.lsp.buf.hover()
                end
            end, "LSP hover info")
            nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
            nmap("gI", telescope.lsp_implementations, "Go to implementation")
            nmap("gd", telescope.lsp_definitions, "Go to definition")
            nmap("gr", vim.lsp.buf.references, "Go to references")

            nmap("<leader>bO", require("dap").step_out, "Step out")
            nmap("<leader>bb", require("dap").toggle_breakpoint, "Toggle breakpoint")
            nmap("<leader>bc", require("dap").continue, "Continue")
            nmap("<leader>bi", require("dap").step_into, "Step into")
            nmap("<leader>bo", require("dap").step_over, "Step over")
            nmap("<leader>bp", require("dap.ui.widgets").preview, "Preview value")
            nmap("<leader>bq", require("dap").list_breakpoints, "List breakpoints")
            nmap("<leader>bt", require("dapui").toggle, "Toggle debug UI")
            nmap("<leader>bx", require("dap").set_exception_breakpoints, "Set exception breakpoints")

            if client.server_capabilities.signatureHelpProvider then
                require("lsp-overloads").setup(client, {
                    ui = {
                        border = "none",
                    },
                    keymaps = {
                        close_signature = "<m-x>",
                    },
                })
            end

            if client.supports_method "textDocument/formatting" then
                vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

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
                end

                nmap("<c-s>", function()
                    format()
                    vim.cmd.update()
                    vim.cmd.mkview()
                end, "Format and save if modified")
                nmap("<leader>fm", format, "Format document")

                if client.supports_method "textDocument/rangeFormatting" then
                    require("lsp-format-modifications").attach(
                        client,
                        bufnr,
                        { format_callback = format, format_on_save = false, experimental_empty_line_handling = true }
                    )
                    nmap("<leader>fc", "<cmd>FormatModifications<cr>", "Format changes")
                end
            end
        end

        require("mason").setup {}

        local lua_server_installed = vim.fn.executable "lua-language-server" == 1
        if lua_server_installed then
            require("neodev").setup {}
        end

        local lsp = require "lspconfig"
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local function lua_setup()
            lsp.lua_ls.setup {
                capabilities = capabilities,
                on_attach = on_attach,
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

        require("mason-lspconfig").setup {}
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                lsp[server_name].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }
            end,
            omnisharp = function()
                local on_attach_cs = function(client, bufnr)
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
                    on_attach(client, bufnr)
                    vim.keymap.set(
                        "n",
                        "gd",
                        require("omnisharp_extended").lsp_definitions,
                        { desc = "Go to definition", buffer = bufnr }
                    )
                end
                lsp.omnisharp.setup {
                    capabilities = capabilities,
                    on_attach = on_attach_cs,
                    handlers = {
                        ["textDocument/definition"] = require("omnisharp_extended").handler,
                        -- cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
                    },
                }
            end,
            fsautocomplete = function()
                vim.g["fsharp#fsi_keymap"] = "custom"
                vim.g["fsharp#fsi_keymap_send"] = "<leader><cr>"
                vim.g["fsharp#fsi_keymap_toggle"] = "<m-\\>"
                vim.g["fsharp#lsp_codelens"] = 0

                require("ionide").setup {
                    autostart = true,
                    capabilities = capabilities,
                    on_attach = on_attach,
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
                        on_attach = on_attach,
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
            lsp.ccls.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }
        end

        local null_ls = require "null-ls"
        local builtins = null_ls.builtins
        local sources = {
            builtins.code_actions.gitrebase,
            builtins.code_actions.gitsigns,
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
        null_ls.setup { diagnostics_format = "#{m} [#{s}]", on_attach = on_attach, sources = sources }

        require("mason-null-ls").setup {
            handlers = {
                function(source_name, methods)
                    require "mason-null-ls.automatic_setup"(source_name, methods)
                end,
                clang_format = function()
                    null_ls.register(builtins.formatting.clang_format.with { disabled_filetypes = { "cs" } })
                end,
                luacheck = function()
                    null_ls.register(builtins.diagnostics.luacheck.with { extra_args = { "--globals", "vim" } })
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

        require("dapui").setup {}
        require("mason-nvim-dap").setup {
            handlers = {},
        }
    end,
}
