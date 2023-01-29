return {
    "samodostal/image.nvim",
    requires = {
        "nvim-lua/plenary.nvim",
        { "JulesNP/baleia.nvim", branch = "no-submodule" },
    },
    config = function()
        require("image").setup {
            render = {
                min_padding = 2,
                foreground_color = true,
                background_color = true,
            },
        }
    end,
}
