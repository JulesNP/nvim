return {
    {
        "numToStr/Comment.nvim",
        event = "BufRead",
        ft = "markdown",
        opts = {
            toggler = {
                block = "g//",
            },
            opleader = {
                block = "g/",
            },
        },
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        ft = { "markdown" },
        keys = {
            { "<leader>cF", "<cmd>Neogen file<cr>", desc = "Create file annotation" },
            { "<leader>cc", "<cmd>Neogen class<cr>", desc = "Create class annotation" },
            { "<leader>cf", "<cmd>Neogen func<cr>", desc = "Create function annotation" },
            { "<leader>ct", "<cmd>Neogen type<cr>", desc = "Create class annotation" },
        },
        config = {
            snippet_engine = "luasnip",
        },
    },
}
