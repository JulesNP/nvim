return {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
        local trouble = require "trouble"
        trouble.setup {
            auto_jump = { "lsp_definitions", "lsp_implementations", "lsp_type_definitions" },
            signs = {
                hint = "",
                information = "",
                warning = "",
                error = "",
                other = "",
            },
        }
    end,
}
