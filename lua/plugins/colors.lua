return {
    "brenoprata10/nvim-highlight-colors",
    cond = not vim.g.vscode,
    event = "BufRead",
    ft = "markdown",
    opts = {
        enable_tailwind = true,
    },
}
