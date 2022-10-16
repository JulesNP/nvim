return {
    "lukas-reineke/indent-blankline.nvim",
    after = "gruvbox",
    config = function()
        vim.cmd [[highlight IndentBlanklineIndent1 ctermbg=235 guibg=#282828]]
        vim.cmd [[highlight IndentBlanklineIndent2 ctermbg=236 guibg=#262626]]
        require("indent_blankline").setup {
            char = "",
            char_highlight_list = {
                "IndentBlanklineIndent1",
                "IndentBlanklineIndent2",
            },
            space_char_highlight_list = {
                "IndentBlanklineIndent1",
                "IndentBlanklineIndent2",
            },
            show_foldtext = false,
            show_trailing_blankline_indent = false,
        }
    end,
}
