return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        labels = "fjdkslaruvmgheicwoxqptybnzFJDKSLARUVMGHEICWOXQPTYBNZ",
        label = {
            uppercase = false,
        },
        search = {
            incremental = true,
            exclude = {
                "blink-cmp-menu",
                "blink-cmp-documentation",
                "blink-cmp-signature",
                "notify",
                "cmp_menu",
                "noice",
                "flash_prompt",
                function(win)
                    return not vim.api.nvim_win_get_config(win).focusable
                end,
            },
        },
        modes = {
            search = {
                enabled = true,
                jump = { register = false },
            },
            char = {
                enabled = false,
            },
        },
    },
    keys = {
        {
            "<cr>",
            mode = { "o", "x" },
            function()
                require("flash").treesitter()
            end,
            desc = "Flash Treesitter",
        },
        {
            "R",
            mode = { "o", "x" },
            function()
                require("flash").treesitter_search()
            end,
            desc = "Treesitter Search",
        },
        {
            "<c-s>",
            mode = { "c" },
            function()
                require("flash").toggle()
            end,
            desc = "Toggle Flash Search",
        },
    },
}
