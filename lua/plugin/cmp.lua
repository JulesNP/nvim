return {
    "hrsh7th/nvim-cmp",
    requires = {
        "L3MON4D3/LuaSnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "petertriho/cmp-git",
        "rafamadriz/friendly-snippets",
        "saadparwaiz1/cmp_luasnip",
        "windwp/nvim-autopairs",
    },
    config = function()
        local cmp = require "cmp"
        local luasnip = require "luasnip"
        local function has_words_before()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end

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
                ["<c-x>"] = cmp.mapping.abort(),
                ["<cr>"] = cmp.mapping.confirm { select = false },
                ["<down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
                ["<up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
            },
            sources = cmp.config.sources {
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "orgmode" },
                { name = "nvim_lsp" },
                { name = "nvim_lua" },
                { name = "git" },
                { name = "path" },
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
            },
        }

        require("cmp_git").setup {
            filetypes = { "NeogitCommitMessage", "gitcommit", "octo" },
        }

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

        local autopairs = require "nvim-autopairs"
        local rule = require "nvim-autopairs.rule"

        autopairs.setup {
            fast_wrap = {},
        }
        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done {})

        local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
        autopairs.add_rules {
            rule(" ", " "):with_pair(function(opts)
                local pair = opts.line:sub(opts.col - 1, opts.col)
                return vim.tbl_contains({
                    brackets[1][1] .. brackets[1][2],
                    brackets[2][1] .. brackets[2][2],
                    brackets[3][1] .. brackets[3][2],
                }, pair)
            end),
        }
        for _, bracket in pairs(brackets) do
            autopairs.add_rules {
                rule(bracket[1] .. " ", " " .. bracket[2])
                    :with_pair(function()
                        return false
                    end)
                    :with_move(function(opts)
                        return opts.prev_char:match(".%" .. bracket[2]) ~= nil
                    end)
                    :use_key(bracket[2]),
            }
        end
    end,
}
