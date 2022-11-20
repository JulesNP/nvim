return {
    "nvim-orgmode/orgmode",
    requires = { "akinsho/org-bullets.nvim", "folke/which-key.nvim", "nvim-treesitter/nvim-treesitter" },
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
        require("which-key").register {
            ["<leader>o"] = { name = "orgmode" },
        }
    end,
}
