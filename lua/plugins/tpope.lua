return {
    { "tpope/vim-dadbod", event = { "CmdlineEnter", "BufRead" }, ft = "markdown" },
    { "tpope/vim-repeat", event = "BufRead", ft = "markdown" },
    { "tpope/vim-speeddating", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-unimpaired", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-rsi", cond = not vim.g.vscode, event = { "CmdlineEnter", "InsertEnter" } },
}
