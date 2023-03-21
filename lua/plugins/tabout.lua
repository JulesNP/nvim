return {
    "abecodes/tabout.nvim",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    dependencies = "nvim-treesitter",
    config = function()
        require("tabout").setup {
            default_tab = "<tab>",
        }
    end,
}
