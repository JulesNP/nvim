return {
    "abecodes/tabout.nvim",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    dependencies = "nvim-treesitter",
    opts = {
        default_tab = "<tab>",
    },
}
