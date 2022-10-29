return {
    "folke/trouble.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "folke/which-key.nvim" },
    config = function()
        local trouble = require "trouble"
        trouble.setup {
            auto_close = true,
            auto_jump = { "lsp_definitions", "lsp_implementations", "lsp_type_definitions" },
            signs = {
                hint = "",
                information = "",
                warning = "",
                error = "",
                other = "",
            },
        }
        require("which-key").register {
            ["[Q"] = {
                function()
                    trouble.first { skip_groups = true, jump = true }
                end,
                "First trouble item",
            },
            ["[q"] = {
                function()
                    trouble.previous { skip_groups = true, jump = true }
                end,
                "Previous trouble item",
            },
            ["]Q"] = {
                function()
                    trouble.last { skip_groups = true, jump = true }
                end,
                "last trouble item",
            },
            ["]q"] = {
                function()
                    trouble.next { skip_groups = true, jump = true }
                end,
                "Next trouble item",
            },
        }
    end,
}
