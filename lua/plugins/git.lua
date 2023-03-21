return {
    "TimUntersberger/neogit",
    cond = not vim.g.vscode,
    event = "BufRead",
    keys = {
        { "<leader>gP", "<cmd>G push<cr>", desc = "Push" },
        { "<leader>gc", "<cmd>G commit<cr>", desc = "Commit" },
        { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
        { "<leader>gp", "<cmd>G pull<cr>", desc = "Pull" },
    },
    dependencies = {
        "folke/which-key.nvim",
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb",
    },
    config = function()
        local neogit = require "neogit"
        neogit.setup {
            disable_commit_confirmation = true,
            disable_insert_on_commit = false,
            integrations = {
                diffview = true,
            },
        }
        require("which-key").register {
            ["<leader>g"] = { name = "git" },
        }
    end,
}
