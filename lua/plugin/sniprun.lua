return {
    "michaelb/sniprun",
    run = "bash ./install.sh",
    requires = "folke/which-key.nvim",
    config = function()
        local wk = require "which-key"

        require("sniprun").setup {
            display = {
                "VirtualTextOk",
                "LongTempFloatingWindow",
            },
        }

        wk.register { ["<leader>R"] = { "<cmd>SnipRun<cr>", "Run line" } }
        wk.register { ["<leader>R"] = { ":SnipRun<cr>", "Run selection", mode = "x" } }
    end,
}
