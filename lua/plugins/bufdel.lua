return {
    "ojroques/nvim-bufdel",
    cond = not vim.g.vscode,
    cmd = "BufDel",
    keys = {
        { "<leader>x", "<cmd>BufDel<cr>", desc = "Close buffer" },
    },
    opts = {
        next = "alternate",
        quit = false,
    },
}
