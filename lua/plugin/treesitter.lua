return {
    "nvim-treesitter/nvim-treesitter",
    run = function()
        require("nvim-treesitter.install").update { with_sync = true }
    end,
    config = function()
        require("nvim-treesitter.configs").setup {
            highlight = {
                enable = true,
            },
        }
    end,
}
