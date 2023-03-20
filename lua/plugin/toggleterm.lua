return {
    "akinsho/toggleterm.nvim",
    cond = not vim.g.vscode,
    version = "*",
    config = function()
        require("toggleterm").setup {
            open_mapping = "<c-\\>",
        }
    end,
}
