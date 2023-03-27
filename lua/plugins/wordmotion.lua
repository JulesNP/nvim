return {
    "chaoren/vim-wordmotion",
    event = "BufRead",
    ft = "markdown",
    init = function()
        vim.g.wordmotion_mappings = {
            w = "<m-w>",
            b = "<m-b>",
            e = "<m-e>",
            ge = "g<m-e>",
            aw = "a<m-w>",
            iw = "i<m-w>",
            ["<C-R><C-W>"] = "<c-r><m-w>",
            W = "",
            B = "",
            E = "",
            gE = "",
            aW = "",
            iW = "",
            ["<C-R><C-A>"] = "",
        }
    end,
}
