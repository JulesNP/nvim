return {
    "folke/flash.nvim",
    event = "VeryLazy",
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
    config = function()
        require("flash").setup {
            labels = "fjdkslaruvmgheicwoxqptybnzFJDKSLARUVMGHEICWOXQPTYBNZ",
            label = {
                uppercase = false,
            },
            search = {
                incremental = true,
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
        }
        vim.api.nvim_set_hl(0, "FlashLabel", { link = "RedrawDebugRecompose" })
    end,
}
