return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = { { path = "luvit-meta/library", words = { "vim%.uv" } } },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "saghen/blink.cmp",
        lazy = false,
        dependencies = {
            "rafamadriz/friendly-snippets",
            { "kristijanhusak/vim-dadbod-completion", dependencies = { "tpope/vim-dadbod" } },
            "mikavilpas/blink-ripgrep.nvim",
        },
        build = "cargo build --release",
        config = function()
            require("blink.cmp").setup {
                keymap = {
                    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                    ["<C-e>"] = { "hide", "fallback" },
                    ["<C-y>"] = { "select_and_accept", "fallback" },
                    ["<CR>"] = { "accept", "fallback" },
                    ["<C-p>"] = { "select_prev", "fallback" },
                    ["<C-n>"] = { "select_next", "fallback" },
                    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                    ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
                    ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
                },
                highlight = {
                    use_nvim_cmp_as_default = true,
                },
                nerd_font_variant = "mono",
                accept = {
                    auto_brackets = { enabled = true },
                },
                trigger = { signature_help = { enabled = true } },
                sources = {
                    completion = {
                        enabled_providers = { "buffer", "dadbod", "lazydev", "lsp", "path", "ripgrep", "snippets" },
                    },
                    providers = {
                        buffer = { score_offset = -10, fallback_for = {} },
                        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                        lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
                        lsp = { fallback_for = { "lazydev" } },
                        ripgrep = {
                            name = "Ripgrep",
                            module = "blink-ripgrep",
                            score_offset = -30,
                            opts = { context_size = 3 },
                        },
                    },
                },
                windows = {
                    autocomplete = { selection = "auto_insert" },
                    documentation = { auto_show = true },
                },
            }
        end,
    },
}
