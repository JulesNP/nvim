return {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true },
    config = function()
        require("lualine").setup {
            options = {
                disabled_filetypes = { "neo-tree" },
                section_separators = "",
                component_separators = "|",
            },
            extensions = {
                "fugitive",
                "man",
                "quickfix",
                "toggleterm",
            },
        }
    end,
}
