return {
    "hrsh7th/nvim-cmp",
    cond = not vim.g.vscode,
    event = { "CmdlineEnter", "InsertEnter" },
    dependencies = {
        "FelipeLema/cmp-async-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "lukas-reineke/cmp-rg",
        "petertriho/cmp-git",
        "saadparwaiz1/cmp_luasnip",
        { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" } },
        { "kristijanhusak/vim-dadbod-completion", dependencies = { "tpope/vim-dadbod" } },
    },
    config = function()
        local cmp = require "cmp"
        local luasnip = require "luasnip"
        local function has_words_before()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = {
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
                ["<c-n>"] = cmp.mapping.select_next_item(),
                ["<c-p>"] = cmp.mapping.select_prev_item(),
                ["<c-space>"] = cmp.mapping.complete {},
                ["<m-x>"] = cmp.mapping.abort(),
                ["<cr>"] = cmp.mapping.confirm { select = false },
                ["<down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
                ["<up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "orgmode" },
                { name = "nvim_lsp" },
                { name = "nvim_lua" },
                { name = "git" },
                { name = "async_path" },
                { name = "calc" },
                { name = "emoji" },
                {
                    name = "buffer",
                    option = {
                        get_bufnrs = function()
                            local bufs = {}
                            for _, win in ipairs(vim.api.nvim_list_wins()) do
                                bufs[vim.api.nvim_win_get_buf(win)] = true
                            end
                            return vim.tbl_keys(bufs)
                        end,
                    },
                },
            }, {
                { name = "rg", keyword_length = 2 },
            }),
        }

        require("cmp_git").setup {
            filetypes = { "NeogitCommitMessage", "gitcommit", "octo" },
        }

        cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
            sources = {
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "calc" },
                {
                    name = "buffer",
                    option = {
                        get_bufnrs = function()
                            local bufs = {}
                            for _, win in ipairs(vim.api.nvim_list_wins()) do
                                bufs[vim.api.nvim_win_get_buf(win)] = true
                            end
                            return vim.tbl_keys(bufs)
                        end,
                    },
                },
                { name = "vim-dadbod-completion" },
            },
        })

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources {
                { name = "path" },
                { name = "cmdline" },
            },
        })
    end,
}
