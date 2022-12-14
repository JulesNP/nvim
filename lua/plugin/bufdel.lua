return {
    "ojroques/nvim-bufdel",
    requires = "folke/which-key.nvim",
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
