return {
    {
        "NeogitOrg/neogit",
        cond = not vim.g.vscode,
        keys = vim.g.vscode and {} or {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        config = function()
            require("neogit").setup {
                disable_commit_confirmation = true,
                disable_insert_on_commit = false,
                integrations = {
                    diffview = true,
                },
            }
        end,
    },
}
