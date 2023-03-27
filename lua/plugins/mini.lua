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
        local ts = require("mini.ai").gen_spec.treesitter
        require("mini.ai").setup {
            custom_textobjects = {
                F = ts { a = "@function.outer", i = "@function.inner" },
                a = ts { a = "@parameter.outer", i = "@parameter.inner" },
                c = ts { a = "@comment.outer", i = "@comment.inner" },
                f = ts { a = "@call.outer", i = "@call.inner" },
                g = function()
                    local from = { line = 1, col = 1 }
                    local to = {
                        line = vim.fn.line "$",
                        col = math.max(vim.fn.getline("$"):len(), 1),
                    }
                    return { from = from, to = to }
                end,
                o = ts { a = { "@conditional.outer", "@loop.outer" }, i = { "@conditional.inner", "@loop.inner" } },
            },
        }
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
