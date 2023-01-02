return {
    "abecodes/tabout.nvim",
    after = "nvim-cmp",
    requires = "nvim-treesitter",
    config = function()
        require("tabout").setup {
            default_tab = "<tab>",
        }
    end,
}
