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

    if include_rzls then
        config.handlers = require "rzls.roslyn_handlers"

        require("roslyn").setup {
            args = {
                "--logLevel=Information",
                "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
                "--razorSourceGenerator=" .. vim.fs.joinpath(
                    vim.fn.stdpath "data" --[[@as string]],
                    "mason",
                    "packages",
                    "roslyn",
                    "libexec",
                    "Microsoft.CodeAnalysis.Razor.Compiler.dll"
                ),
                "--razorDesignTimePath=" .. vim.fs.joinpath(
                    vim.fn.stdpath "data" --[[@as string]],
                    "mason",
                    "packages",
                    "rzls",
                    "libexec",
                    "Targets",
                    "Microsoft.NET.Sdk.Razor.DesignTime.targets"
                ),
            },
            config = config,
        }

        ---@diagnostic disable-next-line: missing-fields
        require("rzls").setup {
            capabilities = capabilities,
        }
        vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
            group = vim.api.nvim_create_augroup("RazorFiletype", { clear = true }),
            pattern = "*.cshtml",
            callback = function()
                vim.bo.filetype = "razor"
            end,
        })
    else
        require("roslyn").setup { config = config }
    end
end

return {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    event = { "BufRead", "CmdlineEnter", "InsertEnter" },
    cmd = { "Mason" },
    keys = vim.g.vscode and {} or {
        { "<leader>m", "<cmd>Mason<cr>", desc = "Open Mason" },
    },
    dependencies = {
        "saghen/blink.cmp",
        "jay-babu/mason-null-ls.nvim",
        "jay-babu/mason-nvim-dap.nvim",
        "joechrisellis/lsp-format-modifications.nvim",
        "kevinhwang91/nvim-ufo",
        "mfussenegger/nvim-dap",
        "nvim-lua/plenary.nvim",
        "nvim-neotest/nvim-nio",
        "nvimtools/none-ls.nvim",
        "pmizio/typescript-tools.nvim",
        "rcarriga/nvim-dap-ui",
        "seblj/roslyn.nvim",
        "tris203/rzls.nvim",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        { "JulesNP/Ionide-vim", branch = "indent" },
        {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
                "MunifTanjim/nui.nvim",
                "SmiteshP/nvim-navic",
            },
            opts = {
                window = {
                    border = "rounded",
                },
                lsp = { auto_attach = true },
            },
        },
    },
    init = function()
        -- Prevent auto setup of Ionide
        vim.g["fsharp#lsp_auto_setup"] = 0
        vim.g["fsharp#lsp_recommended_colorscheme"] = 0

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
            ui = {
                border = "rounded",
            },
        }
        local lspconfig = require "lspconfig"
        local mason_lsp = require "mason-lspconfig"
        mason_lsp.setup()

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

        mason_lsp.setup_handlers {
            function(server_name)
                lspconfig[server_name].setup {
                    capabilities = capabilities,
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
            ts_ls = function()
                require("typescript-tools").setup {
                    settings = {
                        expose_as_code_action = "all",
                        ts_ls_file_preferences = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                }
            end,
        }
        -- Mason's install of lua-language-server doesn't work on Termux, so use globally installed version if available
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

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(require "hover", { border = "rounded" })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

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
                vim.keymap.set("n", "K", function()
                    local peek = require("ufo").peekFoldedLinesUnderCursor()
                    if not peek then
                        vim.lsp.buf.hover()
                    end
                end, opts "Hover")
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
                vim.keymap.set({ "n", "v" }, "gra", function()
                    _G.code_action_repeat = false
                    vim.o.operatorfunc = "v:lua.code_action"
                    return "g@l"
                end, { expr = true, buffer = bufnr, desc = "Code action" })
                vim.keymap.set("n", "grd", vim.lsp.buf.declaration, opts "Go to declaration")
                vim.keymap.set("n", "gri", vim.lsp.buf.implementation, opts "Go to implementation")
                vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts "Rename")
                vim.keymap.set("n", "grr", vim.lsp.buf.references, opts "Go to references")
                vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, opts "Go to type definition")
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
                        vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
                        require("lsp-format-modifications").attach(client, bufnr, {
                            format_callback = format,
                            format_on_save = false,
                            experimental_empty_line_handling = true,
                        })
                        vim.keymap.set("n", "<leader>fc", "<cmd>FormatModifications<cr>", opts "Format changes")
                    end
                end
            end,
        })
    end,
}
