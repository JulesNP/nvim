return {
    "brenoprata10/nvim-highlight-colors",
    cond = not vim.g.vscode,
    event = "BufRead",
    config = function()
        require("nvim-highlight-colors").setup {
            enable_tailwind = true,
        }
    end,
}
