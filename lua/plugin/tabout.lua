return {
    "abecodes/tabout.nvim",
    after = "nvim-cmp",
    dependencies = "nvim-treesitter",
    config = function()
        require("tabout").setup {
            default_tab = "<tab>",
        }
    end,
}
