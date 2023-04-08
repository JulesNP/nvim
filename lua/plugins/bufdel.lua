return {
    "ojroques/nvim-bufdel",
    cond = not vim.g.vscode,
    cmd = "BufDel",
    keys = vim.g.vscode and {} or {
        { "<leader>x", "<cmd>BufDel<cr>", desc = "Close buffer" },
    },
    opts = {
        next = "alternate",
        quit = false,
    },
}
