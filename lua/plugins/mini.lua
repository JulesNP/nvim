return {
    "echasnovski/mini.nvim",
    version = false,
    event = "BufRead",
    ft = "markdown",
    keys = vim.g.vscode and {} or {
        {
            "<leader>x",
            function()
                require("mini.bufremove").delete()
            end,
            desc = "Close buffer",
        },
    },
    config = function()
        require("mini.ai").setup {}
        require("mini.bufremove").setup {}
        require("mini.move").setup {}
        if not vim.g.vscode and not vim.g.neovide then
            local animate = require "mini.animate"
            animate.setup {
                cursor = {
                    enable = false,
                },
                scroll = {
                    timing = animate.gen_timing.linear { duration = 30, unit = "total" },
                },
                resize = {
                    enable = false,
                },
                open = {
                    enable = false,
                },
                close = {
                    enable = false,
                },
            }
        end
    end,
}
