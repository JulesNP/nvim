local function match_at_cursor(pattern)
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local text = vim.api.nvim_get_current_line():sub(col, col - 1 + pattern:len())
    return text == pattern
end

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
        dependencies = "rafamadriz/friendly-snippets",
        version = "v0.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = { preset = "default" },

            highlight = {
                -- sets the fallback highlight groups to nvim-cmp's highlight groups
                -- useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release, assuming themes add support
                use_nvim_cmp_as_default = true,
            },
            -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",

            -- experimental auto-brackets support
            accept = { auto_brackets = { enabled = true } },

            -- experimental signature help support
            trigger = { signature_help = { enabled = true } },
        },
        -- allows extending the enabled_providers array elsewhere in your config
        -- without having to redefining it
        opts_extend = { "sources.completion.enabled_providers" },
    },
}
