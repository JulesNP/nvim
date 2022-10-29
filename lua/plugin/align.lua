return {
    "junegunn/vim-easy-align",
    requires = "folke/which-key.nvim",
    config = function()
        local wk = require "which-key"
        wk.register { gl = { "<plug>(EasyAlign)", "Align items" } }
        wk.register({ gl = { "<plug>(EasyAlign)", "Align items" } }, { mode = "x" })
    end,
}
