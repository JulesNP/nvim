return {
    "neovim/nvim-lspconfig",
    requires = {
        "Decodetalkers/csharpls-extended-lsp.nvim",
        "folke/neodev.nvim",
        "folke/trouble.nvim",
        "folke/which-key.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "jose-elias-alvarez/null-ls.nvim",
        "nvim-lua/plenary.nvim",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
    },
    config = function()
        local trouble = require "trouble"
        local wk = require "which-key"
        wk.register {
            ["<leader>e"] = { vim.diagnostic.open_float, "View diagnostic" },
            ["<leader>q"] = {
                function()
                    vim.cmd.normal "m'"
                    trouble.open "workspace_diagnostics"
                end,
                "List diagnostics",
            },
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
                gI = {
                    function()
                        vim.cmd.normal "m'"
                        trouble.close()
                        trouble.open "lsp_implementations"
                    end,
                    "Go to implementation",
                },
                gR = {
                    function()
                        vim.cmd.normal "m'"
                        trouble.open "lsp_references"
                    end,
                    "Go to references",
                },
                gd = { vim.lsp.buf.definition, "Go to definition" },
                ["<leader>"] = {
                    D = { vim.lsp.buf.type_definition, "Type definition" },
                    ca = { vim.lsp.buf.code_action, "Code action" },
                    rn = { vim.lsp.buf.rename, "Rename" },
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
                            return fmt_client.name ~= "tsserver"
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

        local lsp = require "lspconfig"
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        require("neodev").setup {}
        require("mason").setup {}
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
        }

        local null_ls = require "null-ls"
        require("null-ls").setup {
            on_attach = on_attach,
            sources = {
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.formatting.clang_format.with {
                    disabled_filetypes = { "cs" },
                },
                null_ls.builtins.formatting.prettier.with {
                    extra_filetypes = { "pug" },
                },
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.hover.dictionary,
            },
        }
    end,
}
