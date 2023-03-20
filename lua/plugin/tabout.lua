return {
    "abecodes/tabout.nvim",
    enabled = not vim.g.vscode,
    after = "nvim-cmp",
    dependencies = "nvim-treesitter",
    config = function()
        require("tabout").setup {
            default_tab = "<tab>",
        }
    end,
}
