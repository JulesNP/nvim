return {
    "abecodes/tabout.nvim",
    config = function()
        require("tabout").setup {
            default_tab = "<tab>",
        }
    end,
    wants = { "nvim-treesitter" },
    after = { "nvim-cmp" },
}
