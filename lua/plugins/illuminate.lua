return {
    "RRethy/vim-illuminate",
    event = "BufRead",
    ft = "markdown",
    config = function()
        require("illuminate").configure {
            providers = vim.g.vscode and { "treesitter", "regex" } or {
                "lsp",
                "treesitter",
                "regex",
            },
            min_count_to_highlight = 2,
        }
    end,
}
