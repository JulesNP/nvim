return {
    "folke/which-key.nvim",
    config = function()
        local wk = require "which-key"
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
            ["<m-s>"] = { "<cmd>wall<bar>mkview<cr>", "Save all modified buffers" },
            ["<esc>"] = { "<cmd>nohlsearch<bar>diffupdate<cr>", "Clear search highlights" },
            ["<leader>n"] = { "<cmd>enew<bar>set filetype=markdown<cr>", "New buffer" },
            ["<leader>X"] = { "<cmd>bdelete<cr>", "Close window and buffer" },
            ["<leader>p"] = {
                name = "packer",
                s = { "<cmd>PackerSync<cr>", "PackerSync" },
                c = { "<cmd>PackerCompile<cr>", "PackerCompile" },
            },
            ["<leader>t"] = {
                name = "toggle",
                s = { "<cmd>windo set scrollbind! cursorbind!<cr>", "Toggle scroll/cursor sync" },
                w = { "<cmd>set wrap!<cr>", "Toggle word wrap" },
                v = {
                    function()
                        vim.o.virtualedit = vim.o.virtualedit == "" and "all" or ""
                    end,
                    "Toggle virtual editing",
                },
            },
            ["<leader>v"] = { "<cmd>WhichKey<cr>", "View keymaps" },
            gA = { "ga", "Show ASCII value" },
            gB = { "<cmd>bprevious<cr>", "Go to previous buffer" },
            gb = { "<cmd>bnext<cr>", "Go to next buffer" },
            j = { [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "Down", expr = true },
            k = { [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Up", expr = true },
        }

        wk.register({
            ["<c-h>"] = { termcodes "<c-\\><c-n><c-w>h", "Go to the left window" },
            ["<c-j>"] = { termcodes "<c-\\><c-n><c-w>j", "Go to the down window" },
            ["<c-k>"] = { termcodes "<c-\\><c-n><c-w>k", "Go to the up window" },
            ["<c-l>"] = { termcodes "<c-\\><c-n><c-w>l", "Go to the right window" },
            ["<c-s-v>"] = { "<c-r>+", "Paste from clipboard" },
            ["<m-x>"] = { termcodes "<c-\\><c-n>", "Go to Normal mode" },
        }, { mode = "t" })

        wk.register({
            ["<"] = { "<gv", "Shift left" },
            [">"] = { ">gv", "Shift left" },
            ["<leader>s"] = { ":sort<cr>", "Sort selection" },
            ["<leader>v"] = { "<cmd>WhichKey<cr>", "View keymaps" },
            j = { [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], "Down", expr = true },
            k = { [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], "Up", expr = true },
            y = { "myy`y", "Yank selection" },
            Y = { "myY`y", "Yank selection linewise" },
        }, { mode = "x" })
    end,
}
