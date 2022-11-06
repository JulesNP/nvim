return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
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
            use_popups_for_input = true,
            use_default_mappings = false,
            source_selector = {
                statusline = true,
            },
            window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
                width = 28, -- applies to left and right positions
                mappings = {
                    ["<2-LeftMouse>"] = "open_drop",
                    ["<cr>"] = "open_with_window_picker",
                    ["<tab>"] = "toggle_node",
                    ["?"] = "show_help",
                    ["P"] = { "toggle_preview", config = { use_float = true } },
                    ["R"] = "refresh",
                    ["S"] = "split_with_window_picker",
                    ["T"] = "open_tabnew",
                    ["[["] = "prev_source",
                    ["]]"] = "next_source",
                    ["a"] = { "add", config = { show_path = "relative" } },
                    ["c"] = { "copy", config = { show_path = "relative" } },
                    ["d"] = "delete",
                    ["gS"] = "git_add_all",
                    ["gu"] = "git_unstage_file",
                    ["gs"] = "git_add_file",
                    ["gr"] = "git_revert_file",
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
                        ["/"] = "fuzzy_finder",
                        ["D"] = "fuzzy_finder_directory",
                        --["/"] = "filter_as_you_type", -- this was the default until v1.28
                        ["f"] = "filter_on_submit",
                        ["<C-x>"] = "clear_filter",
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["[c"] = "prev_git_modified",
                        ["]c"] = "next_git_modified",
                    },
                },
                find_by_full_path_words = true,
                follow_current_file = true,
                hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                -- in whatever position is specified in window.position
                -- "open_current",-- netrw disabled, opening a directory opens within the
                -- window like netrw would, regardless of window.position
                -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                -- instead of relying on nvim autocmd events.
            },
            buffers = {
                bind_to_cwd = true,
                follow_current_file = true, -- This will find and focus the file in the active buffer every time
                -- the current file is changed while the tree is open.
                group_empty_dirs = true, -- when true, empty directories will be grouped together
                window = {
                    mappings = {
                        ["<bs>"] = "navigate_up",
                        ["."] = "set_root",
                        ["bd"] = "buffer_delete",
                    },
                },
            },
            git_status = {
                window = {
                    mappings = {},
                },
            },
        }

        vim.cmd [[nnoremap \ :Neotree toggle<cr>]]
    end,
}
