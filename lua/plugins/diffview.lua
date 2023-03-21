return {
    "sindrets/diffview.nvim",
    cond = not vim.g.vscode,
    event = "BufRead",
    ft = "markdown",
    dependencies = { "folke/which-key.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
        local wk = require "which-key"

        require("diffview").setup {
            enhanced_diff_hl = true,
            keymaps = {
                view = {
                    ["\\"] = "<cmd>DiffviewFocusFiles<cr>",
                    q = "<cmd>DiffviewClose<cr>",
                },
                file_history_panel = {
                    ["\\"] = "<cmd>DiffviewToggleFiles<cr>",
                    q = "<cmd>DiffviewClose<cr>",
                },
                file_panel = {
                    ["\\"] = "<cmd>DiffviewToggleFiles<cr>",
                    q = "<cmd>DiffviewClose<cr>",
                },
            },
        }
        wk.register {
            ["<leader>d"] = {
                name = "diffview",
                d = { "<cmd>DiffviewOpen<cr>", "Open diffview" },
                f = { "<cmd>DiffviewFileHistory %<cr>", "Current file history" },
                h = { "<cmd>DiffviewFileHistory<cr>", "Repository history" },
                o = { "<cmd>DiffviewOpen origin/HEAD<cr>", "Diffview from origin" },
            },
        }
        wk.register { ["<leader>d"] = { ":DiffviewFileHistory<cr>", "View selection history", mode = "x" } }
    end,
}
