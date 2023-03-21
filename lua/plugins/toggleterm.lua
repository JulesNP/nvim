return {
    "akinsho/toggleterm.nvim",
    cond = not vim.g.vscode,
    version = "*",
    keys = vim.g.vscode and {} or {
        { "<c-\\>", "<cmd>ToggleTerm<cr>", desc = "Open ToggleTerm" },
        { "<c-\\>", "<cmd>ToggleTerm<cr>", desc = "Open ToggleTerm", mode = "t" },
    },
    opts = {},
}
