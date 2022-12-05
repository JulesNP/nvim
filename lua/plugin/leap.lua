return {
    "ggandor/leap.nvim",
    requires = "folke/which-key.nvim",
    config = function()
        local leap = require "leap"
        local wk = require "which-key"

        leap.opts.labels = {
            "f",
            "j",
            "d",
            "k",
            "s",
            "l",
            "a",
            "r",
            "u",
            "v",
            "m",
            "g",
            "h",
            "e",
            "i",
            "w",
            "o",
            "x",
            "q",
            "p",
            "b",
            "n",
            "z",
            "F",
            "J",
            "D",
            "K",
            "S",
            "L",
            "A",
            "R",
            "U",
            "V",
            "M",
            "G",
            "H",
            "E",
            "I",
            "W",
            "O",
            "X",
            "Q",
            "P",
            "B",
            "N",
            "Z",
        }

        local function leap_in_win()
            leap.leap { target_windows = { vim.fn.win_getid() } }
        end
        local function leap_anywhere()
            leap.leap {
                target_windows = vim.tbl_filter(function(win)
                    return vim.api.nvim_win_get_config(win).focusable
                end, vim.api.nvim_tabpage_list_wins(0)),
            }
        end

        wk.register { ["g<cr>"] = { leap_anywhere, "Leap to letter pair" } }

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("LeapSetup", { clear = true }),
            pattern = "*",
            callback = function(opts)
                if vim.g.vscode or vim.bo.buftype == "" then
                    wk.register({ ["<cr>"] = { leap_anywhere, "Leap to letter pair" } }, { buffer = opts.buf })
                    wk.register { ["<cr>"] = { leap_in_win, "Leap to letter pair" }, mode = "o", buffer = opts.buf }
                    wk.register { ["<cr>"] = { leap_in_win, "Leap to letter pair", mode = "x", buffer = opts.buf } }
                end
            end,
        })
    end,
}
