return {
    "brenoprata10/nvim-highlight-colors",
    enabled = not vim.g.vscode,
    config = function()
        require("nvim-highlight-colors").setup {
            enable_tailwind = true,
        }
    end,
}
