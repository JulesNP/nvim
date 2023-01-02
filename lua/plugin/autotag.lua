return {
    "windwp/nvim-ts-autotag",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
        require("nvim-ts-autotag").setup()
    end
}
