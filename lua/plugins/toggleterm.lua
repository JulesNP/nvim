return {
    "akinsho/toggleterm.nvim",
    cond = not vim.g.vscode,
    version = "*",
    keys = vim.g.vscode and {} or {
        { "<c-\\>", '<cmd>exe v:count1 . "ToggleTerm"<cr>', desc = "Open ToggleTerm" },
        { "<c-\\>", '<cmd>exe v:count1 . "ToggleTerm"<cr>', desc = "Open ToggleTerm", mode = "t" },
    },
    config = function()
        local width = vim.api.nvim_win_get_width(0)
        require("toggleterm").setup {
            size = width >= 160 and 80 or 15,
            direction = width >= 160 and "vertical" or "horizontal",
        }
    end,
}
