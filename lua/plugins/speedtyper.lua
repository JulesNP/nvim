return {
    "NStefan002/speedtyper.nvim",
    cond = not vim.g.vscode,
    cmd = "Speedtyper",
    keys = vim.g.vscode and {} or { { "<leader>st", "<cmd>Speedtyper<cr>", desc = "Open Speedtyper" } },
    opts = {},
}
