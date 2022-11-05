return {
    "folke/which-key.nvim",
    config = function()
        local wk = require "which-key"
        local function termcodes(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        require("which-key.plugins.presets").operators["v"] = nil
        wk.setup {
            plugins = {
                spelling = {
                    enabled = true,
                },
            },
        }

        wk.register {
            ["<a-h>"] = { "<c-w><lt>", "Decrease width" },
            ["<a-j>"] = { "<c-w>+", "Increase height" },
            ["<a-k>"] = { "<c-w>-", "Decrease height" },
            ["<a-l>"] = { "<c-w>>", "Increase width" },
            ["<c-h>"] = { "<c-w>h", "Go to the left window" },
            ["<c-j>"] = { "<c-w>j", "Go to the down window" },
            ["<c-k>"] = { "<c-w>k", "Go to the up window" },
            ["<c-l>"] = { "<c-w>l", "Go to the right window" },
            ["<c-q>"] = { "<c-w>q", "Quit a window" },
            ["<c-s>"] = { "<cmd>update<bar>mkview<cr>", "Save if modified" },
            ["<esc>"] = { "<Cmd>nohlsearch<Bar>diffupdate<CR>", "Clear search highlights" },
            ["<leader>b"] = { "<cmd>enew<cr>", "New buffer" },
            ["<leader>p"] = {
                name = "packer",
                s = { "<cmd>PackerSync<cr>", "PackerSync" },
                c = { "<cmd>PackerCompile<cr>", "PackerCompile" },
            },
            ["<leader>wk"] = { "<cmd>WhichKey<cr>", "WhichKey" },
            gA = { "ga", "Show ASCII value" },
            gB = { "<cmd>bprevious<cr>", "Go to previous buffer" },
            gb = { "<cmd>bnext<cr>", "Go to next buffer" },
            j = { [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "Down", expr = true },
            k = { [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Up", expr = true },
        }

        wk.register({
            ["<c-h>"] = { termcodes "<C-\\><C-n><C-w>h", "Go to the left window" },
            ["<c-j>"] = { termcodes "<C-\\><C-n><C-w>j", "Go to the down window" },
            ["<c-k>"] = { termcodes "<C-\\><C-n><C-w>k", "Go to the up window" },
            ["<c-l>"] = { termcodes "<C-\\><C-n><C-w>l", "Go to the right window" },
            ["<c-s-v>"] = { "<c-r>+", "Paste from clipboard" },
            ["<c-x>"] = { termcodes "<C-\\><C-n>", "Go to Normal mode" },
        }, { mode = "t" })

        wk.register({
            ["<"] = { "<gv", "Shift left" },
            [">"] = { ">gv", "Shift left" },
            j = { [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "Down", expr = true },
            k = { [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Up", expr = true },
            y = { "myy`y", "Yank selection" },
            Y = { "myY`y", "Yank selection linewise" },
        }, { mode = "x" })
    end,
}
