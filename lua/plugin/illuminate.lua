return {
    "RRethy/vim-illuminate",
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
