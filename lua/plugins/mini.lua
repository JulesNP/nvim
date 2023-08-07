return {
    "echasnovski/mini.nvim",
    version = false,
    event = "BufRead",
    ft = { "lazy", "markdown" },
    keys = vim.g.vscode and {} or {
        {
            "\\",
            function()
                local MiniFiles = require "mini.files"
                if not MiniFiles.close() then
                    MiniFiles.open()
                end
            end,
            desc = "Open file browser",
        },
        {
            "-",
            function()
                local MiniFiles = require "mini.files"
                MiniFiles.open(vim.api.nvim_buf_get_name(0))
                MiniFiles.reveal_cwd()
            end,
            desc = "Open file browser",
        },
    },
    init = function()
        if vim.g.vscode then
            vim.g.miniindentscope_disable = true
        else
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("IndentScopeDisable", { clear = true }),
                callback = function()
                    if vim.bo.buftype ~= "" or vim.bo.filetype == "toggleterm" or vim.bo.filetype == "dbout" then
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
                a = require("mini.ai").gen_spec.argument { separator = "[,;]" },
                c = ts { a = "@comment.outer", i = "@comment.inner" },
                g = function()
                    local from = { line = 1, col = 1 }
                    local to = { line = vim.fn.line "$", col = math.max(vim.fn.getline("$"):len(), 1) }
                    return { from = from, to = to }
                end,
                o = ts { a = { "@conditional.outer", "@loop.outer" }, i = { "@conditional.inner", "@loop.inner" } },
            },
            n_lines = 100,
        }
        require("mini.align").setup {}

        require("mini.indentscope").setup {
            draw = {
                delay = 25,
                animation = require("mini.indentscope").gen_animation.none(),
                priority = 20,
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
            n_lines = 50,
            search_method = "cover_or_next",
        }
        vim.keymap.del("x", "ys")
        vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
        vim.keymap.set("n", "yss", "ys_", { remap = true })

        if not vim.g.vscode then
            local MiniFiles = require "mini.files"

            local show_dotfiles = false

            local filter_show = function()
                return true
            end

            local filter_hide = function(fs_entry)
                return not vim.startswith(fs_entry.name, ".")
            end

            local toggle_dotfiles = function()
                show_dotfiles = not show_dotfiles
                local new_filter = show_dotfiles and filter_show or filter_hide
                MiniFiles.refresh { content = { filter = new_filter } }
            end

            local files_set_cwd = function()
                local cur_entry_path = MiniFiles.get_fs_entry().path
                local cur_directory = vim.fs.dirname(cur_entry_path)
                vim.fn.chdir(cur_directory)
            end

            local map_split = function(buf_id, lhs, direction)
                local rhs = function()
                    local fs_entry = MiniFiles.get_fs_entry()
                    local is_at_file = fs_entry ~= nil and fs_entry.fs_type == "file"

                    if is_at_file then
                        local new_target_window
                        vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
                            vim.cmd(direction .. " split")
                            new_target_window = vim.api.nvim_get_current_win()
                        end)
                        MiniFiles.set_target_window(new_target_window)
                    end

                    MiniFiles.go_in()
                end

                local desc = "Split " .. direction
                vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
            end

            vim.api.nvim_create_autocmd("User", {
                group = vim.api.nvim_create_augroup("MiniFilesMappings", { clear = true }),
                pattern = "MiniFilesBufferCreate",
                callback = function(args)
                    local buf_id = args.data.buf_id
                    vim.keymap.set("n", "-", function()
                        MiniFiles.go_out()
                    end, { buffer = buf_id, desc = "Go out of directory" })
                    vim.keymap.set("n", "<cr>", function()
                        local fs_entry = MiniFiles.get_fs_entry()
                        local is_at_file = fs_entry ~= nil and fs_entry.fs_type == "file"
                        MiniFiles.go_in()
                        if is_at_file then
                            MiniFiles.close()
                        end
                    end, { buffer = buf_id, desc = "Go in entry" })
                    vim.keymap.set("n", "<c-q>", function()
                        MiniFiles.close()
                    end, { buffer = buf_id, desc = "Close" })
                    vim.keymap.set("n", "<esc>", function()
                        MiniFiles.close()
                    end, { buffer = buf_id, desc = "Close" })
                    vim.keymap.set("n", "g~", files_set_cwd, { buffer = buf_id, desc = "Set CWD" })
                    map_split(buf_id, "gs", "horizontal")
                    map_split(buf_id, "gv", "vertical")
                    vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
                end,
            })

            MiniFiles.setup {
                content = {
                    filter = filter_hide,
                },
                mappings = {
                    close = "q",
                    go_in = "<tab>",
                    go_in_plus = "l",
                    go_out = "h",
                    go_out_plus = "",
                    reset = "<bs>",
                    reveal_cwd = "@",
                    show_help = "g?",
                    synchronize = "<c-s>",
                    trim_left = "<",
                    trim_right = ">",
                },
                windows = {
                    preview = true,
                    width_focus = 40,
                    width_preview = 30,
                },
            }
        end
        if not vim.g.vscode and not vim.g.neovide then
            local animate = require "mini.animate"
            animate.setup {
                cursor = {
                    timing = animate.gen_timing.linear { duration = 50, unit = "total" },
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
