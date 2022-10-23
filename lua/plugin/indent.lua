return {
    "lukas-reineke/indent-blankline.nvim",
    after = "gruvbox",
    config = function()
        vim.cmd "highlight IndentBlanklineIndent1 guifg=#262626 gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent2 guifg=#242424 gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent3 guifg=#222222 gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent4 guifg=#202020 gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent5 guifg=#1E1E1E gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent6 guifg=#1C1C1C gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent7 guifg=#1A1A1A gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent8 guifg=#181818 gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent9 guifg=#161616 gui=nocombine"
        vim.cmd "highlight IndentBlanklineIndent10 guifg=#141414 gui=nocombine"
        require("indent_blankline").setup {
            show_first_indent_level = false,
            show_foldtext = false,
            char = "▏",
            char_highlight_list = {
                "IndentBlanklineIndent1",
                "IndentBlanklineIndent2",
                "IndentBlanklineIndent3",
                "IndentBlanklineIndent4",
                "IndentBlanklineIndent5",
                "IndentBlanklineIndent6",
                "IndentBlanklineIndent7",
                "IndentBlanklineIndent8",
                "IndentBlanklineIndent9",
                "IndentBlanklineIndent10",
            },
        }
    end,
}
