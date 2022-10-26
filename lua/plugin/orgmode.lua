return {
    "nvim-orgmode/orgmode",
    requires = { "nvim-treesitter/nvim-treesitter", "akinsho/org-bullets.nvim" },
    config = function()
        require("orgmode").setup_ts_grammar()
        require("orgmode").setup {
            org_agenda_files = "~/org/*",
            org_default_notes_file = "~/org/notes.org",
            org_todo_keywords = { "TODO(t)", "NEXT", "|", "DONE" },
            org_hide_emphasis_markers = true,
        }
        require("org-bullets").setup {}
    end,
}
