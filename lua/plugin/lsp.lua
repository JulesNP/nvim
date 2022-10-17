-- vim: fdm=marker
return {
    "VonHeikemen/lsp-zero.nvim",
    requires = { -- {{{
        -- LSP Support
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "jose-elias-alvarez/null-ls.nvim" },

        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "petertriho/cmp-git" },
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-calc" },
        { "hrsh7th/cmp-emoji" },

        -- Snippets
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets" },

        -- Other requirements
        { "folke/neodev.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "windwp/nvim-autopairs" },
        { "ray-x/lsp_signature.nvim" },
    }, -- }}}
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

        local lsp = require "lsp-zero"
        lsp.set_preferences { -- {{{
            suggest_lsp_servers = true,
            setup_servers_on_start = true,
            set_lsp_keymaps = false,
            configure_diagnostics = false,
            cmp_capabilities = true,
            manage_nvim_cmp = false,
            call_servers = "local",
        } -- }}}

        local neodev = require("neodev").setup {}
        lsp.configure("sumneko_lua", neodev)

        lsp.on_attach(function(_, bufnr)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            require("lsp_signature").on_attach({ -- {{{
                bind = true,
                handler_opts = {
                    border = "none",
                },
                hint_prefix = "↳ ",
                hint_scheme = "DiagnosticHint",
            }, bufnr) -- }}}

            wk.register {
                K = { vim.lsp.buf.hover, "LSP hover info", buffer = bufnr },
                gD = { vim.lsp.buf.declaration, "Go to declaration", buffer = bufnr },
                gI = { vim.lsp.buf.implementation, "Go to implementation", buffer = bufnr },
                gR = { vim.lsp.buf.references, "Go to references", buffer = bufnr },
                gd = { vim.lsp.buf.definition, "Go to definition", buffer = bufnr },
                ["<leader>"] = {
                    D = { vim.lsp.buf.type_definition, "Type definition", buffer = bufnr },
                    ca = { vim.lsp.buf.code_action, "Code action", buffer = bufnr },
                    fm = { -- {{{
                        function()
                            vim.lsp.buf.format { async = true }
                        end,
                        "Format document",
                        buffer = bufnr,
                    }, -- }}}
                    rn = { vim.lsp.buf.rename, "Rename", buffer = bufnr },
                },
                ["<leader>w"] = {
                    name = "workspace",
                    a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder", buffer = bufnr },
                    r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder", buffer = bufnr },
                    l = { -- {{{
                        function()
                            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                        end,
                        "List workspace folders",
                        buffer = bufnr,
                    }, -- }}}
                },
            }
        end)

        lsp.setup()

        local cmp = require "cmp"
        local luasnip = require "luasnip"
        local has_words_before = function() -- {{{
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end -- }}}
        cmp.setup {
            snippet = { -- {{{
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            }, -- }}}
            mapping = cmp.mapping.preset.insert { -- {{{
                ["<tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() and has_words_before() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s", "x" }),
                ["<s-tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s", "x" }),
                ["<c-b>"] = cmp.mapping.scroll_docs(-4),
                ["<c-f>"] = cmp.mapping.scroll_docs(4),
                ["<c-space>"] = cmp.mapping.complete {},
                ["<c-e>"] = cmp.mapping.abort(),
                ["<cr>"] = cmp.mapping.confirm { select = false },
            }, -- }}}
            sources = cmp.config.sources { -- {{{
                { name = "luasnip" },
                { name = "nvim_lua" },
                { name = "nvim_lsp" },
                { name = "git" },
                { name = "path" },
                { name = "calc" },
                { name = "emoji" },
                {
                    name = "buffer",
                    option = {
                        get_bufnrs = function()
                            return vim.api.nvim_list_bufs()
                        end,
                    },
                },
            }, -- }}}
        }

        require("cmp_git").setup {
            filetypes = { "NeogitCommitMessage", "gitcommit", "octo" },
        }

        cmp.setup.cmdline({ "/", "?" }, { -- {{{
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources {
                { name = "buffer" },
            },
        }) -- }}}

        cmp.setup.cmdline(":", { -- {{{
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources {
                { name = "path" },
                { name = "cmdline" },
            },
        }) -- }}}

        require("nvim-autopairs").setup {} -- {{{
        local handlers = require "nvim-autopairs.completion.handlers"
        cmp.event:on(
            "confirm_done",
            require("nvim-autopairs.completion.cmp").on_confirm_done {
                filetypes = {
                    fsharp = {
                        [" "] = {
                            kind = {
                                cmp.lsp.CompletionItemKind.Function,
                                cmp.lsp.CompletionItemKind.Method,
                            },
                            handler = handlers["*"],
                        },
                    },
                },
            }
        ) -- }}}

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "none",
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "none",
        })

        local null_ls = require "null-ls"
        require("null-ls").setup { -- {{{
            sources = {
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.formatting.clang_format,
                null_ls.builtins.formatting.prettier.with {
                    extra_filetypes = { "pug" },
                },
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.hover.dictionary,
            },
        } -- }}}
    end,
}
