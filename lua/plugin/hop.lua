return {
    "phaazon/hop.nvim",
    branch = "v2",
    requires = "folke/which-key.nvim",
    config = function()
        local hop = require "hop"
        local wk = require "which-key"

        hop.setup { teasing = false }

        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("HopEnter", { clear = true }),
            pattern = "*",
            callback = function(opts)
                if vim.g.vscode or vim.bo.buftype == "" then
                    wk.register({
                        gw = { hop.hint_words, "Word hop" },
                        ["<cr>"] = { hop.hint_char2, "2-character hop" },
                    }, { buffer = opts.buf })
                    wk.register {
                        ["<cr>"] = {
                            function()
                                hop.hint_char2 { hint_offset = -1 }
                            end,
                            "2-character hop",
                        },
                        mode = "o",
                        buffer = opts.buf,
                    }
                    wk.register { ["<cr>"] = { hop.hint_char2, "2-character hop", mode = "x", buffer = opts.buf } }
                end
            end,
        })
    end,
}
