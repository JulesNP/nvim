return {
    "phaazon/hop.nvim",
    branch = "v2",
    requires = "folke/which-key.nvim",
    config = function()
        local hop = require "hop"
        local wk = require "which-key"

        hop.setup { teasing = false }

        wk.register {
            gw = { hop.hint_words, "Word hop" },
            ["<cr>"] = { hop.hint_char2, "2-character hop" },
        }
        wk.register {
            ["<cr>"] = {
                function()
                    hop.hint_char2 { hint_offset = -1 }
                end,
                "2-character hop",
                mode = "o",
            },
        }
        wk.register { ["<cr>"] = { hop.hint_char2, "2-character hop", mode = "x" } }

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("QuickfixEnter", { clear = true }),
            pattern = "qf",
            callback = function(opts)
                wk.register { ["<cr>"] = { "<cr>", "Go to item" }, buffer = opts.buf }
            end,
        })
    end,
}
