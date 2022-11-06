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
            use_default_mappings = true,
            source_selector = {
                statusline = true,
            },
            window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
                width = "33%", -- applies to left and right positions
                mappings = {
                    ["<tab>"] = "toggle_node",
                    ["<2-LeftMouse>"] = "open",
                    ["<esc>"] = "revert_preview",
                    ["P"] = { "toggle_preview", config = { use_float = true } },
                    ["S"] = "split_with_window_picker",
                    ["s"] = "vsplit_with_window_picker",
                    ["t"] = "open_tabnew",
                    ["<cr>"] = "open_drop",
                    ["T"] = "open_tab_drop",
                    ["w"] = "open_with_window_picker",
                    ["C"] = "close_node",
                    ["z"] = "close_all_nodes",
                    ["Z"] = "expand_all_nodes",
                    ["R"] = "refresh",
                    ["a"] = {
                        "add",
                        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                        config = {
                            show_path = "relative", -- "none", "relative", "absolute"
                        },
                    },
                    ["A"] = "add_directory", -- also accepts the config.show_path option.
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["y"] = "copy_to_clipboard",
                    ["x"] = "cut_to_clipboard",
                    ["p"] = "paste_from_clipboard",
                    ["c"] = "copy", -- takes text input for destination, also accepts the config.show_path option
                    ["m"] = "move", -- takes text input for destination, also accepts the config.show_path option
                    ["q"] = "close_window",
                    ["?"] = "show_help",
                    ["<"] = "prev_source",
                    [">"] = "next_source",
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
                        ["[g"] = "prev_git_modified",
                        ["]g"] = "next_git_modified",
                    },
                },
                find_by_full_path_words = true, -- `false` means it only searches the tail of a path.
                -- `true` will change the filter into a full path
                -- search with space as an implicit ".*", so
                -- `fi init`
                -- will match: `./sources/filesystem/init.lua
                --find_command = "fd", -- this is determined automatically, you probably don't need to set it
                --find_args = {  -- you can specify extra args to pass to the find command.
                --  fd = {
                --  "--exclude", ".git",
                --  "--exclude",  "node_modules"
                --  }
                --},
                ---- or use a function instead of list of strings
                --find_args = function(cmd, path, search_term, args)
                --  if cmd ~= "fd" then
                --    return args
                --  end
                --  --maybe you want to force the filter to always include hidden files:
                --  table.insert(args, "--hidden")
                --  -- but no one ever wants to see .git files
                --  table.insert(args, "--exclude")
                --  table.insert(args, ".git")
                --  -- or node_modules
                --  table.insert(args, "--exclude")
                --  table.insert(args, "node_modules")
                --  --here is where it pays to use the function, you can exclude more for
                --  --short search terms, or vary based on the directory
                --  if string.len(search_term) < 4 and path == "/home/cseickel" then
                --    table.insert(args, "--exclude")
                --    table.insert(args, "Library")
                --  end
                --  return args
                --end,
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
                    mappings = {
                        ["A"] = "git_add_all",
                        ["gu"] = "git_unstage_file",
                        ["ga"] = "git_add_file",
                        ["gr"] = "git_revert_file",
                        ["gc"] = "git_commit",
                        ["gp"] = "git_push",
                        ["gg"] = "git_commit_and_push",
                    },
                },
            },
        }

        vim.cmd [[nnoremap \ :Neotree toggle<cr>]]
    end,
}
