return {
    "uga-rosa/ccc.nvim",
    cond = not vim.g.vscode,
    event = { "BufRead", "CmdlineEnter", "InsertEnter" },
    keys = vim.g.vscode and {} or {
        { "<leader>cp", "<cmd>CccPick<cr>", desc = "Color picker" },
    },
    config = function()
        local ccc = require "ccc"
        ccc.setup {
            highlighter = { auto_enable = true, lsp = true },
            inputs = {
                ccc.input.okhsl,
                ccc.input.rgb,
                ccc.input.hsl,
                ccc.input.cmyk,
            },
        }
    end,
}
