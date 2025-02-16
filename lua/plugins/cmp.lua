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
        cond = not vim.g.vscode,
        event = { "CmdlineEnter", "InsertEnter" },
        dependencies = {
            "kristijanhusak/vim-dadbod-ui",
            "mikavilpas/blink-ripgrep.nvim",
            "moyiz/blink-emoji.nvim",
            "rafamadriz/friendly-snippets",
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
                default = {
                    "lazydev",
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    "dadbod",
                    "emoji",
                    "ripgrep",
                },
                providers = {
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                    },
                    emoji = {
                        module = "blink-emoji",
                        name = "Emoji",
                        score_offset = 15,
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                    ripgrep = {
                        name = "Ripgrep",
                        module = "blink-ripgrep",
                        score_offset = -5,
                    },
                },
            },

            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
}
