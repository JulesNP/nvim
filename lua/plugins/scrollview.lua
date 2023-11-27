return {
    "dstein64/nvim-scrollview",
    config = function()
        require("scrollview").setup {
            excluded_filetypes = { "alpha" },
            signs_on_startup = {
                "conflicts",
                "cursor",
                "diagnostics",
                "loclist",
                "marks",
                "quickfix",
                "search",
                "spell",
            },
            signs_show_in_folds = true,
            cursor_priority = 0,
            diagnostics_hint_symbol = "󰌵 ",
            diagnostics_info_symbol = "󰋼 ",
            diagnostics_warn_symbol = " ",
            diagnostics_error_symbol = " ",
        }
    end,
}
