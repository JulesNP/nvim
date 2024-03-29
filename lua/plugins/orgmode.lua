return {
    "nvim-orgmode/orgmode",
    cond = not vim.g.vscode,
    keys = vim.g.vscode and {} or {
        {
            "<leader>oa",
            function()
                require("orgmode").action("agenda.prompt", { opts = { buffer = false, desc = "org agenda" } })
            end,
            desc = "org agenda",
        },
        {
            "<leader>oc",
            function()
                require("orgmode").action("capture.prompt", { opts = { buffer = false, desc = "org capture" } })
            end,
            desc = "org capture",
        },
    },
    ft = "org",
    dependencies = { "akinsho/org-bullets.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("orgmode").setup_ts_grammar()
        require("orgmode").setup {
            calendar_week_start_day = 0,
            org_agenda_files = { "~/org/**/*" },
            org_default_notes_file = "~/org/refile.org",
            org_todo_keywords = { "TODO(t)", "NEXT", "WAIT", "|", "DONE" },
            org_hide_emphasis_markers = true,
            win_split_mode = "auto",
        }
        require("org-bullets").setup {}
    end,
}
