return {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    cond = not vim.g.vscode,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {},
}
