return {
    {
        "kristijanhusak/vim-dadbod-ui",
        cond = not vim.g.vscode,
        dependencies = "tpope/vim-dadbod",
        event = { "BufRead", "CmdlineEnter", "InsertEnter" },
        ft = { "dbui", "dbout", "sql", "mysql", "plsql", "psql" },
        keys = vim.g.vscode and {} or {
            {
                "<leader>db",
                "<cmd>DBUIToggle<cr>",
                desc = "Dadbod UI",
            },
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_force_echo_notifications = 1
        end,
    },
    { "tpope/vim-abolish", event = { "BufRead", "CmdlineEnter", "InsertEnter" } },
    { "tpope/vim-repeat", event = { "BufRead", "CmdlineEnter", "InsertEnter" } },
    { "tpope/vim-speeddating", event = { "BufRead", "CmdlineEnter", "InsertEnter" } },
    { "tpope/vim-rsi", cond = not vim.g.vscode, event = { "BufRead", "CmdlineEnter", "InsertEnter" } },
}
