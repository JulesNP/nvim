return {
    "folke/which-key.nvim",
    requires = "folke/trouble.nvim",
    config = function()
        local wk = require "which-key"
        local trouble = require "trouble"
        local function termcodes(str)
            return vim.api.nvim_replace_termcodes(str, true, true, true)
        end

        wk.setup {
            plugins = {
                spelling = {
                    enabled = true,
                },
            },
        }
        wk.register {
            ["[Q"] = {
                function()
                    trouble.first { skip_groups = true, jump = true }
                end,
                "First trouble item",
            },
            ["[q"] = {
                function()
                    trouble.previous { skip_groups = true, jump = true }
                end,
                "Previous trouble item",
            },
            ["]Q"] = {
                function()
                    trouble.last { skip_groups = true, jump = true }
                end,
                "last trouble item",
            },
            ["]q"] = {
                function()
                    trouble.next { skip_groups = true, jump = true }
                end,
                "Next trouble item",
            },
            ["<C-h>"] = { termcodes "<C-\\><C-n><C-w>h", "Go to the left window", mode = "t" },
            ["<C-j>"] = { termcodes "<C-\\><C-n><C-w>j", "Go to the down window", mode = "t" },
            ["<C-k>"] = { termcodes "<C-\\><C-n><C-w>k", "Go to the up window", mode = "t" },
            ["<C-l>"] = { termcodes "<C-\\><C-n><C-w>l", "Go to the right window", mode = "t" },
            ["<C-x>"] = { termcodes "<C-\\><C-n>", "Go to Normal mode", mode = "t" },
            ["<esc>"] = { "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", "Clear search highlights" },
            ["<c-s>"] = {
                function()
                    vim.lsp.buf.format()
                    vim.cmd "update"
                end,
                "Format and save if modified",
            },
            ["<c-q>"] = { "<c-w>q", "Quit a window" },
            ["<c-h>"] = { "<c-w>h", "Go to the left window" },
            ["<c-j>"] = { "<c-w>j", "Go to the down window" },
            ["<c-k>"] = { "<c-w>k", "Go to the up window" },
            ["<c-l>"] = { "<c-w>l", "Go to the right window" },
            ["<a-h>"] = { "<c-w><lt>", "Decrease width" },
            ["<a-j>"] = { "<c-w>+", "Increase height" },
            ["<a-k>"] = { "<c-w>-", "Decrease height" },
            ["<a-l>"] = { "<c-w>>", "Increase width" },
            ["<leader>b"] = { "<cmd>enew<cr>", "New buffer" },
            ["<leader>p"] = {
                name = "packer",
                s = { "<cmd>PackerSync<cr>", "PackerSync" },
                c = { "<cmd>PackerCompile<cr>", "PackerCompile" },
            },
            ["<leader>wk"] = { "<cmd>WhichKey<cr>", "WhichKey" },
            ["<leader>x"] = { "<cmd>bdelete<cr>", "Close buffer" },
            gb = { "<cmd>bnext<cr>", "Go to next buffer" },
            gB = { "<cmd>bprevious<cr>", "Go to previous buffer" },
            j = { [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "Down", expr = true },
            k = { [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Up", expr = true },
        }
    end,
}
