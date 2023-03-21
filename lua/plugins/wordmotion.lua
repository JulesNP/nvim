return {
    "chaoren/vim-wordmotion",
    event = "BufRead",
    ft = "markdown",
    init = function()
        vim.g.wordmotion_prefix = "<leader>"
    end,
}
