return {
    "lukas-reineke/indent-blankline.nvim",
    after = "gruvbox",
    config = function()
        require("indent_blankline").setup {
            char = "▏",
            show_foldtext = false,
        }
    end,
}
