return {
    "ojroques/nvim-bufdel",
    enabled = not vim.g.vscode,
    dependencies = "folke/which-key.nvim",
    config = function()
        require("bufdel").setup {
            next = "alternate",
            quit = false,
        }
        require("which-key").register {
            ["<leader>x"] = { "<cmd>BufDel<cr>", "Close buffer" },
        }
    end,
}
