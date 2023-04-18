return {
    {
        "kristijanhusak/vim-dadbod-ui",
        cond = not vim.g.vscode,
        dependencies = "tpope/vim-dadbod",
        event = { "CmdlineEnter", "BufRead" },
        ft = { "sql", "mysql", "plsql" },
        keys = vim.g.vscode and {} or {
            { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Dadbod UI" },
        },
    },
    { "tpope/vim-repeat", event = "BufRead", ft = "markdown" },
    { "tpope/vim-speeddating", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-unimpaired", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-rsi", cond = not vim.g.vscode, event = { "CmdlineEnter", "InsertEnter" } },
}
