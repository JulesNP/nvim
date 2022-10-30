return {
    "junegunn/vim-easy-align",
    requires = "folke/which-key.nvim",
    config = function()
        local wk = require "which-key"
        wk.register { ga = { "<plug>(EasyAlign)", "Align items" } }
        wk.register({ ga = { "<plug>(EasyAlign)", "Align items" } }, { mode = "x" })
    end,
}
