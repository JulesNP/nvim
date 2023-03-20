return {
    "brenoprata10/nvim-highlight-colors",
    cond = not vim.g.vscode,
    event = "BufRead",
    ft = "markdown",
    config = function()
        require("nvim-highlight-colors").setup {
            enable_tailwind = true,
        }
    end,
}
