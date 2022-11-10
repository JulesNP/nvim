return {
    "phaazon/hop.nvim",
    branch = "v2",
    requires = "folke/which-key.nvim",
    config = function()
        local hop = require "hop"
        local wk = require "which-key"

        hop.setup {}

        wk.register {
            gw = { hop.hint_words, "Word hop" },
            ["<cr>"] = { hop.hint_char2, "2-character hop" },
        }
        wk.register { ["<cr>"] = { hop.hint_char2, "2-character hop", mode = "o" } }
        wk.register { ["<cr>"] = { hop.hint_char2, "2-character hop", mode = "x" } }
    end,
}
