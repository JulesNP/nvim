return {
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
        require("nvim-ts-autotag").setup()
    end
}
