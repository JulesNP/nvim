return {
    "windwp/nvim-ts-autotag",
    enabled = not vim.g.vscode,
    after = "nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require("nvim-ts-autotag").setup()
    end
}
