return {
    "echasnovski/mini.nvim",
    version = false,
    event = "BufRead",
    ft = { "lazy", "markdown" },
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
        if vim.g.vscode then
            vim.g.miniindentscope_disable = true
        else
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("IndentScopeDisable", { clear = true }),
                callback = function()
                    if vim.bo.buftype ~= "" then
                        vim.b.miniindentscope_disable = true
                    end
                end,
            })
        end
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
        require("mini.align").setup {}
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
        require("mini.splitjoin").setup {
            detect = {
                separator = "[,;]",
            },
            join = {
                hooks_post = { require("mini.splitjoin").gen_hook.pad_brackets { brackets = { "%b[]", "%b{}" } } },
            },
        }
        require("mini.surround").setup {
            mappings = {
                add = "ys",
                delete = "ds",
                find = "",
                find_left = "",
                highlight = "",
                replace = "cs",
                update_n_lines = "",
            },
            search_method = "cover_or_next",
        }
        vim.keymap.del("x", "ys")
        vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
        vim.keymap.set("n", "yss", "ys_", { remap = true })

        if not vim.g.vscode and not vim.g.neovide then
            local animate = require "mini.animate"
            animate.setup {
                cursor = {
                    timing = animate.gen_timing.linear { duration = 100, unit = "total" },
                },
                scroll = {
                    timing = animate.gen_timing.linear { duration = 50, unit = "total" },
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
