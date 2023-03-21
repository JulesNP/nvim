return {
    { "tpope/vim-repeat", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-speeddating", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-surround", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-unimpaired", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-rsi", cond = not vim.g.vscode, event = { "CmdlineEnter", "InsertEnter" } },
}
