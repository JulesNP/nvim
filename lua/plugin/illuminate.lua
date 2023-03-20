return {
    "RRethy/vim-illuminate",
    cond = not vim.g.vscode,
    event = "BufRead",
    config = function()
        require("illuminate").configure {
            providers = {
                "lsp",
                "treesitter",
            },
            min_count_to_highlight = 2,
        }
    end,
}
