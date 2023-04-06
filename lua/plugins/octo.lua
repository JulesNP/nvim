return {
    "pwntester/octo.nvim",
    cond = not vim.g.vscode,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    event = "CmdlineEnter",
    keys = vim.g.vscode and {} or {
        { "<leader>8", "<cmd>Octo actions<cr>", desc = "Octo actions" },
        { "<leader>f8", "<cmd>Octo search<cr>", desc = "Find GitHub issue/PR" },
    },
    opts = {},
}
