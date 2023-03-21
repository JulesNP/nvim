return {
    "caenrique/nvim-maximize-window-toggle",
    cond = not vim.g.vscode,
    keys = {
        { "<leader>z", "<cmd>ToggleOnly<Enter>", desc = "Maximize/restore window" },
    },
}
