return {
    "akinsho/toggleterm.nvim",
    enabled = not vim.g.vscode,
    version = "*",
    config = function()
        require("toggleterm").setup {
            open_mapping = "<c-\\>",
        }
    end,
}
