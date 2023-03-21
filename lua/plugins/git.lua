return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
        },
        cond = not vim.g.vscode,
        event = "CmdlineEnter",
        keys = vim.g.vscode and {} or {
            { "<leader>gP", "<cmd>G push<cr>", desc = "Push" },
            { "<leader>gc", "<cmd>G commit<cr>", desc = "Commit" },
            { "<leader>gp", "<cmd>G pull<cr>", desc = "Pull" },
        },
    },
    {
        "TimUntersberger/neogit",
        cond = not vim.g.vscode,
        keys = vim.g.vscode and {} or {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        opts = {
            disable_commit_confirmation = true,
            disable_insert_on_commit = false,
            integrations = {
                diffview = true,
            },
        },
    },
}
