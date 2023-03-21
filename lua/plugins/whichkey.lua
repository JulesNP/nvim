return {
    "folke/which-key.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    keys = {
        { "<leader>v", "<cmd>WhichKey<cr>", desc = "View keymaps", mode = { "n", "x" } },
    },
    config = function()
        local wk = require "which-key"

        local options = {
            plugins = {
                spelling = {
                    enabled = true,
                },
            },
        }
        if vim.g.neovide then
            options.window = {
                winblend = 25,
            }
        end
        wk.setup(options)

        wk.register {
            ["<leader>d"] = { name = "diffview" },
            ["<leader>f"] = { name = "find" },
            ["<leader>g"] = { name = "git", f = { name = "find" } },
            ["<leader>h"] = { name = "hunk" },
            ["<leader>l"] = { name = "lsp" },
            ["<leader>o"] = { name = "orgmode" },
            ["<leader>r"] = { name = "refactor" },
            ["<leader>s"] = { name = "session" },
            ["<leader>t"] = { name = "toggle" },
        }
    end,
}
