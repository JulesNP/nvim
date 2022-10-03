return {
    "folke/which-key.nvim",
    config = function()
        local wk = require "which-key"
        local function termcodes(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        wk.setup {
            spelling = {
                enabled = true,
            },
        }
        wk.register {
            ["<C-h>"] = { termcodes "<C-\\><C-n><C-w>h", "Go to the left window", mode = "t" },
            ["<C-j>"] = { termcodes "<C-\\><C-n><C-w>j", "Go to the down window", mode = "t" },
            ["<C-k>"] = { termcodes "<C-\\><C-n><C-w>k", "Go to the up window", mode = "t" },
            ["<C-l>"] = { termcodes "<C-\\><C-n><C-w>l", "Go to the right window", mode = "t" },
            ["<C-x>"] = { termcodes "<C-\\><C-n>", "Go to Normal mode", mode = "t" },
            ["<c-s>"] = { "<cmd>update<cr>", "Save if modified" },
            ["<c-q>"] = { "<c-w>q", "Quit a window" },
            ["<c-h>"] = { "<c-w>h", "Go to the left window" },
            ["<c-j>"] = { "<c-w>j", "Go to the down window" },
            ["<c-k>"] = { "<c-w>k", "Go to the up window" },
            ["<c-l>"] = { "<c-w>l", "Go to the right window" },
            ["<a-h>"] = { "<c-w><lt>", "Decrease width" },
            ["<a-j>"] = { "<c-w>+", "Increase height" },
            ["<a-k>"] = { "<c-w>-", "Decrease height" },
            ["<a-l>"] = { "<c-w>>", "Increase width" },
            ["<leader>ps"] = { "<cmd>PackerSync<cr>", "PackerSync" },
        }
    end,
}
