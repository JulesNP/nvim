return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
        "folke/which-key.nvim",
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        {
            -- only needed if you want to use the commands with "_with_window_picker" suffix
            "s1n7ax/nvim-window-picker",
            tag = "v1.*",
            config = function()
                require("window-picker").setup {
                    autoselect_one = true,
                    include_current = false,
                    filter_rules = {
                        -- filter using buffer options
                        bo = {
                            -- if the file type is one of following, the window will be ignored
                            filetype = { "neo-tree", "neo-tree-popup", "notify" },

                            -- if the buffer type is one of following, the window will be ignored
                            buftype = { "terminal", "quickfix" },
                        },
                    },
                    other_win_hl_color = "#e35e4f",
                }
            end,
        },
    },
    config = function()
        vim.g.neo_tree_remove_legacy_commands = 1

        require("neo-tree").setup {
            close_if_last_window = true,
            popup_border_style = "rounded",
            use_default_mappings = false,
            source_selector = {
                statusline = true,
                highlight_tab = "StatusLineNC",
                highlight_tab_active = "StatusLine",
                highlight_background = "StatusLineNC",
                highlight_separator = "StatusLineNC",
                highlight_separator_active = "StatusLine",
            },
            window = {
                width = 28,
                mappings = {
                    ["<2-LeftMouse>"] = "open_drop",
                    ["<cr>"] = "open_with_window_picker",
                    ["<tab>"] = "toggle_node",
                    ["?"] = "show_help",
                    ["P"] = { "toggle_preview" },
                    ["R"] = "refresh",
                    ["S"] = "split_with_window_picker",
                    ["T"] = "open_tabnew",
                    ["[["] = "prev_source",
                    ["]]"] = "next_source",
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["c"] = { "copy", config = { show_path = "relative" } },
                    ["d"] = "delete",
                    ["<leader>hS"] = "git_add_all",
                    ["<leader>hu"] = "git_unstage_file",
                    ["<leader>hs"] = "git_add_file",
                    ["<leader>hr"] = "git_revert_file",
                    ["m"] = { "move", config = { show_path = "relative" } },
                    ["p"] = "paste_from_clipboard",
                    ["q"] = "close_window",
                    ["r"] = "rename",
                    ["s"] = "vsplit_with_window_picker",
                    ["t"] = "open_tab_drop",
                    ["x"] = "cut_to_clipboard",
                    ["y"] = "copy_to_clipboard",
                    ["zc"] = "close_node",
                    ["zm"] = "close_all_nodes",
                    ["zr"] = "expand_all_nodes",
                },
            },
            filesystem = {
                window = {
                    mappings = {
                        ["H"] = "toggle_hidden",
                        ["/"] = "filter_as_you_type",
                        ["<esc>"] = "clear_filter",
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["[c"] = "prev_git_modified",
                        ["]c"] = "next_git_modified",
                    },
                },
                find_by_full_path_words = true,
                follow_current_file = true,
                use_libuv_file_watcher = true,
            },
            buffers = {
                window = {
                    mappings = {
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["bd"] = "buffer_delete",
                    },
                },
            },
        }

        vim.cmd [[nnoremap \ :Neotree toggle<cr>]]
        require("which-key").register {
            ["\\"] = { "<cmd>silent Neotree toggle<cr>", "Toggle file tree" },
        }
    end,
}
