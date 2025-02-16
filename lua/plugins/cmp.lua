return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            { "Kaiser-Yang/blink-cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
            "rafamadriz/friendly-snippets",
            "kristijanhusak/vim-dadbod-ui",
            "mikavilpas/blink-ripgrep.nvim",
        },
        version = "*",
        opts = {
            keymap = {
                preset = "none",
                ["<c-d>"] = { "scroll_documentation_down", "fallback" },
                ["<c-e>"] = { "cancel", "fallback" },
                ["<c-n>"] = { "select_next", "fallback" },
                ["<c-p>"] = { "select_prev", "fallback" },
                ["<c-s>"] = { "show_signature", "hide_signature", "fallback" },
                ["<c-space>"] = { "show", "hide", "fallback" },
                ["<c-u>"] = { "scroll_documentation_up", "fallback" },
                ["<c-y>"] = { "select_and_accept", "fallback" },
                ["<cr>"] = { "accept", "fallback" },
                ["<down>"] = { "select_next", "fallback" },
                ["<s-tab>"] = { "snippet_backward", "select_prev", "fallback" },
                ["<tab>"] = { "snippet_forward", "select_next", "fallback" },
                ["<up>"] = { "select_prev", "fallback" },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            completion = {
                list = {
                    selection = {
                        preselect = false,
                    },
                },
                documentation = {
                    auto_show = true,
                },
                ghost_text = {
                    enabled = true,
                },
            },
            sources = {
                default = { "lazydev", "git", "lsp", "path", "snippets", "buffer", "dadbod", "ripgrep" },
                providers = {
                    buffer = {
                        opts = {
                            get_bufnrs = function()
                                return vim.tbl_filter(function(bufnr)
                                    return vim.bo[bufnr].buftype == ""
                                end, vim.api.nvim_list_bufs())
                            end,
                        },
                    },
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                    },
                    git = {
                        module = "blink-cmp-git",
                        name = "Git",
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    ripgrep = {
                        name = "Ripgrep",
                        module = "blink-ripgrep",
                    },
                },
            },

            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
}
