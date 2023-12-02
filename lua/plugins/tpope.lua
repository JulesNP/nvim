return {
    {
        "kristijanhusak/vim-dadbod-ui",
        cond = not vim.g.vscode,
        dependencies = "tpope/vim-dadbod",
        event = { "CmdlineEnter", "BufRead" },
        ft = { "sql", "mysql", "plsql" },
        keys = vim.g.vscode and {} or {
            {
                "<leader>db",
                function()
                    if vim.bo.filetype == "alpha" then
                        vim.cmd "enew"
                        vim.bo.filetype = "text"
                        vim.bo.filetype = "sql"
                    end
                    vim.cmd "DBUIToggle"
                end,
                desc = "Dadbod UI",
            },
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_force_echo_notifications = 1
        end,
    },
    { "tpope/vim-abolish", cond = not vim.g.vscode, event = { "CmdlineEnter" } },
    { "tpope/vim-repeat", event = "BufRead", ft = "text" },
    { "tpope/vim-speeddating", event = "BufRead", ft = "text" },
    { "tpope/vim-rsi", cond = not vim.g.vscode, event = { "CmdlineEnter", "InsertEnter" } },
}
