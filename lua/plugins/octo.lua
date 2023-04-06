return {
    "pwntester/octo.nvim",
    cond = not vim.g.vscode,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    event = "CmdlineEnter",
    opts = {},
}
