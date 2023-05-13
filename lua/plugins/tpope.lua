return {
    {
        "JulesNP/vim-dadbod-ui",
        branch = "nerdfix",
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
                        vim.bo.filetype = "markdown"
                        vim.bo.filetype = "sql"
                    end
                    vim.cmd "DBUIToggle"
                end,
                desc = "Dadbod UI",
            },
        },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
    { "tpope/vim-repeat", event = "BufRead", ft = "markdown" },
    { "tpope/vim-speeddating", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-unimpaired", event = "BufReadPost", ft = "markdown" },
    { "tpope/vim-rsi", cond = not vim.g.vscode, event = { "CmdlineEnter", "InsertEnter" } },
}
