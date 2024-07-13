return {
    {
        "NeogitOrg/neogit",
        tag = vim.fn.has "nvim-0.10" == 1 and "v1.0.0" or "v0.0.1",
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
