return {
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        keys = {
            { "<leader>cF", "<cmd>Neogen file<cr>", desc = "Create file annotation" },
            { "<leader>cc", "<cmd>Neogen class<cr>", desc = "Create class annotation" },
            { "<leader>cf", "<cmd>Neogen func<cr>", desc = "Create function annotation" },
            { "<leader>ct", "<cmd>Neogen type<cr>", desc = "Create class annotation" },
        },
        opts = {
            snippet_engine = "luasnip",
        },
    },
}
