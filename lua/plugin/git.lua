return {
    "TimUntersberger/neogit",
    enabled = not vim.g.vscode,
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
            ["<leader>g"] = {
                name = "git",
                P = { "<cmd>G push<cr>", "Push" },
                c = { "<cmd>G commit<cr>", "Commit" },
                g = { neogit.open, "Open Neogit" },
                p = { "<cmd>G pull<cr>", "Pull" },
            },
        }
    end,
}
