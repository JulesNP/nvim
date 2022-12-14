return {
    "neovim/nvim-lspconfig",
    requires = {
        "Decodetalkers/csharpls-extended-lsp.nvim",
        "folke/neodev.nvim",
        "folke/which-key.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "jose-elias-alvarez/null-ls.nvim",
        "jose-elias-alvarez/typescript.nvim",
        "nvim-lua/plenary.nvim",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
    },
    config = function()
        local wk = require "which-key"
        wk.register {
            ["<leader>e"] = { vim.diagnostic.open_float, "View diagnostic" },
            ["<leader>q"] = { vim.diagnostic.setqflist, "List diagnostics" },
            ["[d"] = { vim.diagnostic.goto_prev, "Previous diagnostic" },
            ["]d"] = { vim.diagnostic.goto_next, "Next diagnostic" },
        }

        local function sign(name, icon)
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end

        sign("DiagnosticSignHint", "")
        sign("DiagnosticSignInfo", "")
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

            wk.register({
                K = { vim.lsp.buf.hover, "LSP hover info" },
                gD = { vim.lsp.buf.declaration, "Go to declaration" },
                gI = { vim.lsp.buf.implementation, "Go to implementation" },
                gR = { vim.lsp.buf.references, "Go to references" },
                gd = { vim.lsp.buf.definition, "Go to definition" },
                ["<leader>"] = {
                    D = { vim.lsp.buf.type_definition, "Type definition" },
                    c = { vim.lsp.buf.code_action, "Code action" },
                    r = {
                        name = "refactor",
                        n = { vim.lsp.buf.rename, "Rename" },
                    },
                },
                ["<leader>w"] = {
                    name = "workspace",
                    a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
                    r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
                    l = {
                        function()
                            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                        end,
                        "List workspace folders",
                    },
                },
            }, { buffer = bufnr })

            if client.supports_method "textDocument/formatting" then
                vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

                local function format()
                    vim.lsp.buf.format {
                        async = false,
                        filter = function(fmt_client)
                            return not vim.tbl_contains({ "tsserver", "sumneko_lua" }, fmt_client.name)
                        end,
                    }
                end

                wk.register({
                    ["<c-s>"] = {
                        function()
                            format()
                            vim.cmd.update()
                            vim.cmd.mkview()
                        end,
                        "Format and save if modified",
                    },
                    ["<leader>fm"] = { format, "Format document" },
                }, { buffer = bufnr })
            end
        end

        local lua_server_installed = vim.fn.executable "lua-language-server"
        if lua_server_installed then
            require("neodev").setup {}
        end

        local lsp = require "lspconfig"
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        require("mason").setup {}
        require("mason-lspconfig").setup {}
        require("mason-lspconfig").setup_handlers {
            function(server_name)
                lsp[server_name].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }
            end,
            ["csharp_ls"] = function(server_name)
                lsp[server_name].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    handlers = {
                        ["textDocument/definition"] = require("csharpls_extended").handler,
                    },
                }
            end,
            ["tsserver"] = function(_)
                require("typescript").setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                }
            end,
        }
        -- Mason's install of lua-language-server doesn't work on Termux, so use globally installed version if available
        if not require("mason-registry").is_installed "lua-language-server" and lua_server_installed then
            lsp.sumneko_lua.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }
        end
        -- Set up ccls separately, since it isn't available through Mason
        if vim.fn.executable "ccls" then
            lsp.ccls.setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }
        end

        local builtins = require("null-ls").builtins
        local sources = {
            builtins.code_actions.gitrebase,
            builtins.code_actions.gitsigns,
            builtins.hover.dictionary,
            require "typescript.extensions.null-ls.code-actions",
        }
        local optional = {
            ["clang-format"] = { builtins.formatting.clang_format.with { disabled_filetypes = { "cs" } } },
            ["luacheck"] = { builtins.diagnostics.luacheck.with { extra_args = { "--globals", "vim" } } },
            ["misspell"] = { builtins.diagnostics.misspell },
            ["prettier"] = { builtins.formatting.prettier.with { extra_filetypes = { "pug" } } },
            ["pug-lint"] = { builtins.diagnostics.puglint },
            ["shellcheck"] = { builtins.code_actions.shellcheck },
            ["stylua"] = { builtins.formatting.stylua },
        }
        for key, values in pairs(optional) do
            if vim.fn.executable(key) == 1 then
                for _, value in ipairs(values) do
                    table.insert(sources, value)
                end
            end
        end

        require("null-ls").setup { diagnostics_format = "#{m} [#{s}]", on_attach = on_attach, sources = sources }
    end,
}
