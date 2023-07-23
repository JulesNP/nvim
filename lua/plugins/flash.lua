return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        labels = "fjdkslaruvmgheiwoxqpbnz",
        label = {
            uppercase = false,
        },
        search = {
            incremental = true,
        },
        modes = {
            search = {
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
            "r",
            mode = "o",
            function()
                require("flash").remote()
            end,
            desc = "Remote Flash",
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
