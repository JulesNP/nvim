return {
    "lukas-reineke/indent-blankline.nvim",
    after = "gruvbox",
    config = function()
        vim.cmd "highlight IndentBlanklineIndent1 ctermbg=235 cterm=nocombine guibg=#282828 gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent2 ctermbg=236 cterm=nocombine guibg=#262626 gui=nocombine"
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
        }
    end,
}
