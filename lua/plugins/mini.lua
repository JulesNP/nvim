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
    init = function()
        vim.g.miniindentscope_disable = vim.g.vscode
    end,
    config = function()
        require("mini.ai").setup {}
        require("mini.bufremove").setup {}
        require("mini.indentscope").setup {
            draw = {
                delay = 30,
                animation = require("mini.indentscope").gen_animation.none(),
            },
            options = {
                indent_at_cursor = false,
            },
            symbol = "▏",
        }
        require("mini.move").setup {}
        if not vim.g.vscode and not vim.g.neovide then
            local animate = require "mini.animate"
            animate.setup {
                cursor = {
                    timing = animate.gen_timing.linear { duration = 120, unit = "total" },
                },
                scroll = {
                    timing = animate.gen_timing.linear { duration = 40, unit = "total" },
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
