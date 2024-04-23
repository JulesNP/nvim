local function match_at_cursor(pattern)
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local text = vim.api.nvim_get_current_line():sub(col, col - 1 + pattern:len())
    return text == pattern
end

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
        "lukas-reineke/cmp-rg",
        "petertriho/cmp-git",
        "saadparwaiz1/cmp_luasnip",
        { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" }, build = "make install_jsregexp" },
        { "kristijanhusak/vim-dadbod-completion", dependencies = { "tpope/vim-dadbod" } },
    },
    config = function()
        local cmp = require "cmp"
        local luasnip = require "luasnip"

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
                    elseif luasnip.expand_or_locally_jumpable() then
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
                ["<c-d>"] = cmp.mapping.scroll_docs(-4),
                ["<c-u>"] = cmp.mapping.scroll_docs(4),
                ["<c-n>"] = cmp.mapping.select_next_item(),
                ["<c-p>"] = cmp.mapping.select_prev_item(),
                ["<c-space>"] = cmp.mapping.complete {},
                ["<c-e>"] = cmp.mapping.abort(),
                ["<d-x>"] = cmp.mapping.abort(),
                ["<m-x>"] = cmp.mapping.abort(),
                ["<c-y>"] = cmp.mapping.confirm { select = true },
                ["<cr>"] = cmp.mapping(function(fallback)
                    if not cmp.confirm { select = false } then
                        fallback()
                        if match_at_cursor "></" then
                            local keys = vim.api.nvim_replace_termcodes("<c-o>O", true, true, true)
                            vim.api.nvim_feedkeys(keys, "n", false)
                        end
                    end
                end),
                ["<down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
                ["<up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
            },
            sources = cmp.config.sources {
                { name = "luasnip" },
                { name = "orgmode" },
                { name = "nvim_lsp" },
                { name = "git" },
                { name = "async_path" },
                { name = "calc" },
                { name = "emoji" },
                {
                    name = "rg",
                    priority = -1000,
                    entry_filter = function(entry, _)
                        return not (entry.exact and string.len(entry.completion_item.label) < 4)
                    end,
                    option = {
                        additional_arguments = "--max-depth 4 --one-file-system --smart-case",
                    },
                },
                {
                    name = "buffer",
                    priority = -1000,
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
            },
            window = {
                documentation = {
                    border = "rounded",
                },
            },
        }

        require("cmp_git").setup {
            filetypes = { "NeogitCommitMessage", "gitcommit", "octo" },
        }

        cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
            sources = {
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "async_path" },
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
                { name = "async_path" },
                { name = "cmdline" },
            },
        })

        -- If completion item is Method or Function, add parens
        cmp.event:on("confirm_done", function(ev)
            -- Some LSPs automatically add parens
            if match_at_cursor "(" then
                return
            end

            local item = ev.entry:get_completion_item()
            if item.kind == 2 or item.kind == 3 then
                vim.api.nvim_feedkeys("(", "t", true)
            end
        end)
    end,
}
