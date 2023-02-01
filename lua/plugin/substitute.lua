return {
    "gbprod/substitute.nvim",
    requires = "folke/which-key.nvim",
    config = function()
        local sub = require "substitute"
        local ex = require "substitute.exchange"
        local wk = require "which-key"

        require("substitute").setup {}
        wk.register {
            s = { sub.operator, "Substitute text" },
            ss = { sub.line, "Substitute line" },
            S = { sub.eol, "Substitute to end of line" },
            sx = { ex.operator, "Exchange" },
            sxx = { ex.line, "Exchange lines" },
            sxc = { ex.cancel, "Cancel exchange" },
        }
        wk.register({
            s = { sub.visual, "Substitute selection" },
            X = { ex.visual, "Exchange selection" },
        }, { mode = "x" })
    end,
}
