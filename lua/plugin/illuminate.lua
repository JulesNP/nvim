return {
    "RRethy/vim-illuminate",
    config = function()
        require("illuminate").configure {
            providers = {
                "lsp",
                "treesitter",
            },
            under_cursor = false,
            min_count_to_highlight = 2,
        }
    end,
}
