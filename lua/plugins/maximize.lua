return {
    "caenrique/nvim-maximize-window-toggle",
    cond = not vim.g.vscode,
    keys = vim.g.vscode and {} or {
        { "<leader>z", "<cmd>ToggleOnly<Enter>", desc = "Maximize/restore window" },
    },
}
