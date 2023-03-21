return {
    "RRethy/vim-illuminate",
    event = "BufRead",
    ft = "markdown",
    config = function()
        require("illuminate").configure {
            providers = vim.g.vscode and { "treesitter" } or {
                "lsp",
                "treesitter",
            },
            min_count_to_highlight = 2,
        }
    end,
}
