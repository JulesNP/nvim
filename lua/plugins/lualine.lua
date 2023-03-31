return {
    "nvim-lualine/lualine.nvim",
    cond = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    opts = {
        options = {
            disabled_filetypes = { "neo-tree" },
            section_separators = "",
            component_separators = "|",
        },
        extensions = {
            "fugitive",
            "lazy",
            "man",
            "quickfix",
            "toggleterm",
        },
    },
}
