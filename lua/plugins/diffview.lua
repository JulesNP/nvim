return {
    "sindrets/diffview.nvim",
    cond = not vim.g.vscode,
    event = { "BufRead", "CmdlineEnter" },
    ft = { "NeogitStatus", "lazy" },
    keys = vim.g.vscode and {} or {
        { "<leader>dc", "<cmd>DiffviewOpen --cached<cr>", desc = "Diff of index from HEAD" },
        { "<leader>dd", "<cmd>DiffviewOpen<cr>", desc = "Diff of working tree from index" },
        { "<leader>df", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff history of current file" },
        { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "Diff history of repository" },
        { "<leader>do", "<cmd>DiffviewOpen origin/HEAD<cr>", desc = "Diff of working tree from origin" },
        { "<leader>d", ":DiffviewFileHistory<cr>", desc = "Diff history of current selection", mode = "x" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
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
