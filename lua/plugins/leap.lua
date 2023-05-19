return {
    "ggandor/leap.nvim",
    dependencies = { "ggandor/leap-spooky.nvim" },
    event = "BufRead",
    ft = "markdown",
    config = function()
        local leap = require "leap"

        -- Make new table from string
        local t = {}
        local str = "fjdkslaruvmgheiwoxqpbnzFJDKSLARUVMGHEIWOXQPBNZ"
        for i = 1, #str do
            t[i] = str:sub(i, i)
        end
        leap.opts.labels = t
        leap.opts.highlight_unlabeled_phase_one_targets = true

        if vim.g.vscode then
            vim.api.nvim_set_hl(0, "LeapBackdrop", { fg = "gray", bg = "NONE" })
            vim.api.nvim_set_hl(0, "LeapMatch", { fg = "white", bg = "NONE" })
        end

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

        vim.keymap.set("n", "g<cr>", leap_anywhere, { desc = "Leap to letter pair" })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("LeapSetup", { clear = true }),
            pattern = "*",
            callback = function(opts)
                if
                    (vim.g.vscode or vim.bo.buftype == "" or vim.bo.buftype == "help")
                    and vim.bo.filetype ~= "octo"
                    and vim.bo.filetype ~= "dbui"
                then
                    vim.keymap.set(
                        "n",
                        "<cr>",
                        leap_in_win,
                        { desc = "Leap to letter pair within window", buffer = opts.buf }
                    )
                    vim.keymap.set(
                        "o",
                        "<cr>",
                        leap_in_win,
                        { desc = "Leap to letter pair within window", buffer = opts.buf }
                    )
                    vim.keymap.set(
                        "x",
                        "<cr>",
                        leap_in_win,
                        { desc = "Leap to letter pair within window", buffer = opts.buf }
                    )
                end
            end,
        })

        local ok, illuminate_ref = pcall(require, "illuminate.reference")
        if ok then
            vim.keymap.set("n", "<leader><cr>", function()
                local refs = illuminate_ref.buf_get_references(vim.api.nvim_get_current_buf())
                if not refs or #refs == 0 then
                    return
                end
                local targets = {}
                for _, ref in pairs(refs) do
                    table.insert(targets, {
                        pos = { ref[1][1] + 1, ref[1][2] + 1 },
                    })
                end
                leap.leap { targets = targets, target_windows = { vim.api.nvim_get_current_win() } }
            end, { desc = "Leap to reference" })
        end

        require("leap-spooky").setup {}
    end,
}
