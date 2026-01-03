local function setup_roslyn(capabilities, include_rzls)
    local config = {
        capabilities = capabilities,
        settings = {
            ["csharp|completion"] = {
                dotnet_provide_regex_completions = true,
                dotnet_show_completion_items_from_unimported_namespaces = true,
                dotnet_show_name_completion_suggestions = true,
            },
            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
                dotnet_enable_tests_code_lens = true,
            },
        },
    }

    require("roslyn").setup { config = config }
end

return {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    event = { "BufReadPre", "CmdlineEnter", "InsertEnter" },
    cmd = { "Mason" },
    keys = vim.g.vscode and {} or {
        { "<leader>m", "<cmd>Mason<cr>", desc = "Open Mason" },
    },
    dependencies = {
        "GustavEikaas/easy-dotnet.nvim",
        "saghen/blink.cmp",
        "jay-babu/mason-null-ls.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "joechrisellis/lsp-format-modifications.nvim",
        "mfussenegger/nvim-dap",
        "nvim-lua/plenary.nvim",
        "nvim-neotest/nvim-nio",
        "nvimtools/none-ls.nvim",
        "pmizio/typescript-tools.nvim",
        "rcarriga/nvim-dap-ui",
        "seblyng/roslyn.nvim",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        {
            "hasansujon786/nvim-navbuddy",
            dependencies = {
                "MunifTanjim/nui.nvim",
                "SmiteshP/nvim-navic",
            },
            opts = {
                lsp = { auto_attach = true },
            },
        },
    },
    init = function()
        _G.code_action_repeat = false
        _G.code_action = function()
            vim.lsp.buf.code_action { apply = _G.code_action_repeat }
            _G.code_action_repeat = true
        end
    end,
    config = function()
        require("mason").setup {
            registries = {
                "github:mason-org/mason-registry",
                "github:crashdummyy/mason-registry",
            },
        }
        local lspconfig = require "lspconfig"
        local mason_lsp = require "mason-lspconfig"
        ---@diagnostic disable-next-line: missing-fields
        mason_lsp.setup {}

        local capabilities = require("blink.cmp").get_lsp_capabilities()
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

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

        if
            not require("mason-registry").is_installed "lua-language-server"
            and vim.fn.executable "lua-language-server" == 1
        then
            lua_setup()
        end
        -- Set up ccls separately, since it isn't available through Mason
        if vim.fn.executable "ccls" == 1 then
            lspconfig.ccls.setup {
                capabilities = capabilities,
            }
        end
        if vim.fn.executable "roslyn" == 1 then
            setup_roslyn(capabilities, vim.fn.executable "rzls" == 1)
        end

        local null_ls = require "null-ls"
        local builtins = null_ls.builtins
        local sources = {
            builtins.code_actions.gitrebase,
            builtins.hover.dictionary,
        }
        local optional = {
            prettier = { builtins.formatting.prettier.with { extra_filetypes = { "astro", "pug" } } },
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

        require("easy-dotnet").setup {
            debugger = {
                bin_path = "netcoredbg",
            },
        }
        vim.keymap.set("n", "<leader>dn", ":Dotnet ", { desc = "Use dotnet commands" })

        vim.lsp.handlers["textDocument/hover"] = require "hover"

        vim.keymap.set("n", "<leader>i", vim.diagnostic.open_float, { desc = "View diagnostic info" })
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "List diagnostics" })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            callback = function(args)
                local bufnr = args.buf

                local function opts(desc)
                    return { buffer = bufnr, desc = desc }
                end
                vim.keymap.set("n", "<leader>j", "<cmd>Navbuddy<cr>", opts "LSP Navbuddy finder")
                vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts "Signature help")
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts "List workspace folders")
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts "Hover")
                vim.keymap.set({ "n", "v" }, "gra", function()
                    _G.code_action_repeat = false
                    vim.o.operatorfunc = "v:lua.code_action"
                    return "g@l"
                end, { expr = true, buffer = bufnr, desc = "Code action" })
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

                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil then
                    return
                end

                if client.server_capabilities.completionProvider then
                    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
                end
                if client.server_capabilities.definitionProvider then
                    vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
                end
                if vim.g.show_inlay_hints and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                end

                if client:supports_method "textDocument/foldingRange" then
                    vim.wo[0][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                end
                if client:supports_method "textDocument/formatting" then
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
                        vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
                        vim.keymap.set("n", "<leader>fc", function()
                            require("lsp-format-modifications").format_modifications(client, bufnr)
                        end, opts "Format changes")
                    end
                end
            end,
        })
    end,
}
