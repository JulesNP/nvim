return {
    "sindrets/diffview.nvim",
    cond = not vim.g.vscode,
    ft = { "NeogitStatus", "lazy" },
    keys = {
        { "<leader>dd", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
        { "<leader>df", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
        { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "Repository history" },
        { "<leader>do", "<cmd>DiffviewOpen origin/HEAD<cr>", desc = "Diffview from origin" },
        { "<leader>d", ":DiffviewFileHistory<cr>", desc = "View selection history", mode = "x" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
        enhanced_diff_hl = true,
        keymaps = {
            view = {
                ["\\"] = "<cmd>DiffviewFocusFiles<cr>",
                q = "<cmd>DiffviewClose<cr>",
            },
            file_history_panel = {
                ["\\"] = "<cmd>DiffviewToggleFiles<cr>",
                q = "<cmd>DiffviewClose<cr>",
            },
            file_panel = {
                ["\\"] = "<cmd>DiffviewToggleFiles<cr>",
                q = "<cmd>DiffviewClose<cr>",
            },
        },
    },
}
