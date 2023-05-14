return {
    "nvim-neo-tree/neo-tree.nvim",
    cond = not vim.g.vscode,
    keys = vim.g.vscode and {} or {
        { "\\", "<cmd>silent Neotree reveal<cr>", desc = "Toggle file tree" },
        { "<leader>\\", "<cmd>silent Neotree document_symbols reveal<cr>", desc = "Toggle document symbols" },
    },
    branch = "v2.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        {
            "s1n7ax/nvim-window-picker",
            version = "v1.*",
            config = function()
                require("window-picker").setup {
                    filter_rules = {
                        bo = {
                            buftype = { "terminal", "quickfix" },
                        },
                    },
                    fg_color = "#fbf1c7",
                    other_win_hl_color = "#cc241d",
                }
            end,
        },
    },
    config = function()
        vim.g.neo_tree_remove_legacy_commands = 1

        require("neo-tree").setup {
            close_if_last_window = true,
            open_files_in_last_window = false,
            popup_border_style = "rounded",
            use_default_mappings = false,
            sources = {
                "filesystem",
                "git_status",
                "buffers",
                "document_symbols",
            },
            source_selector = {
                statusline = true,
                highlight_tab = "StatusLineNC",
                highlight_tab_active = "StatusLine",
                highlight_background = "StatusLineNC",
                highlight_separator = "StatusLineNC",
                highlight_separator_active = "StatusLine",
                sources = {
                    {
                        source = "filesystem",
                        display_name = " Files",
                    },
                    {
                        source = "buffers",
                        display_name = "Buffers",
                    },
                    {
                        source = "git_status",
                        display_name = " Git",
                    },
                    {
                        source = "document_symbols",
                        display_name = "Symbols",
                    },
                },
            },
            window = {
                width = 36,
                mappings = {
                    ["<2-LeftMouse>"] = { "open_drop", desc = "Open file" },
                    ["<c-s>"] = { "split_with_window_picker", desc = "Open in horizontal split" },
                    ["<c-v>"] = { "vsplit_with_window_picker", desc = "Open in vertical split" },
                    ["<cr>"] = { "open_with_window_picker", desc = "Open file" },
                    ["<leader>hS"] = { "git_add_all", desc = "Stage all changed files" },
                    ["<leader>hr"] = { "git_revert_file", desc = "Revert file" },
                    ["<leader>hs"] = { "git_add_file", desc = "Stage file" },
                    ["<leader>hu"] = { "git_unstage_file", desc = "Unstage file" },
                    ["<tab>"] = { "toggle_node", desc = "Toggle node" },
                    ["?"] = { "show_help", desc = "Show help" },
                    ["[["] = { "prev_source", desc = "Previous source tab" },
                    ["\\"] = { "close_window", desc = "Close file tree" },
                    ["]]"] = { "next_source", desc = "Next source tab" },
                    P = { "toggle_preview", desc = "Toggle preview" },
                    R = { "refresh", desc = "Refresh file tree" },
                    T = { "open_tabnew", desc = "Open in new tab" },
                    a = { "add", config = { show_path = "relative" }, desc = "Create a file/directory" },
                    c = { "copy", config = { show_path = "relative" }, desc = "Copy to a destination" },
                    d = { "delete", desc = "Delete file" },
                    m = { "move", config = { show_path = "relative" }, desc = "Move to a destination" },
                    o = {
                        function(state)
                            require("neo-tree.sources.filesystem.commands").open_drop(state)
                            vim.cmd "Neotree close"
                        end,
                        desc = "Open file and close file tree",
                    },
                    p = { "paste_from_clipboard", desc = "Paste file from clipboard" },
                    q = { "close_window", desc = "Close file tree" },
                    r = { "rename", desc = "Rename file" },
                    t = { "open_tab_drop", desc = "Open in new tab" },
                    x = { "cut_to_clipboard", desc = "Cut to clipboard" },
                    y = { "copy_to_clipboard", desc = "Copy to clipboard" },
                    zc = { "close_node", desc = "Close node" },
                    zm = { "close_all_nodes", desc = "Close all nodes" },
                    zr = { "expand_all_nodes", desc = "Expand all nodes" },
                },
            },
            filesystem = {
                window = {
                    mappings = {
                        ["."] = { "set_root", desc = "Set root folder" },
                        ["f"] = { "filter_as_you_type", desc = "Filter files" },
                        ["<bs>"] = { "navigate_up", desc = "Navigate up a folder" },
                        ["<esc>"] = { "clear_filter", desc = "Clear filter" },
                        ["<tab>"] = {
                            function(state)
                                require("neo-tree.sources.filesystem.commands").open_drop(state)
                                vim.cmd "Neotree focus"
                            end,
                            desc = "Open item but stay in file tree",
                        },
                        ["[c"] = { "prev_git_modified", desc = "Previous modified file" },
                        ["]c"] = { "next_git_modified", desc = "Next modified file" },
                        H = { "toggle_hidden", desc = "Toggle hidden files" },
                    },
                },
                find_by_full_path_words = true,
                follow_current_file = true,
                use_libuv_file_watcher = true,
            },
            buffers = {
                show_unloaded = true,
                window = {
                    mappings = {
                        ["."] = { "set_root", desc = "Set root folder" },
                        ["<bs>"] = { "navigate_up", desc = "Navigate up a folder" },
                        bd = { "buffer_delete", desc = "Delete buffer" },
                    },
                },
            },
            default_component_configs = {
                icon = {
                    folder_empty = "󰜌",
                    folder_empty_open = "󰜌",
                },
                git_status = {
                    symbols = {
                        renamed = "󰁕",
                        unstaged = "󰄱",
                    },
                },
            },
            document_symbols = {
                follow_cursor = true,
                server_filter = {
                    fn = function(name)
                        return name ~= "null-ls"
                    end,
                },
                kinds = {
                    File = { icon = "󰈙", hl = "Tag" },
                    Namespace = { icon = "󰌗", hl = "Include" },
                    Package = { icon = "󰏖", hl = "Label" },
                    Class = { icon = "󰌗", hl = "Include" },
                    Property = { icon = "󰆧", hl = "@property" },
                    Enum = { icon = "󰒻", hl = "@number" },
                    Function = { icon = "󰊕", hl = "Function" },
                    String = { icon = "󰀬", hl = "String" },
                    Number = { icon = "󰎠", hl = "Number" },
                    Array = { icon = "󰅪", hl = "Type" },
                    Object = { icon = "󰅩", hl = "Type" },
                    Key = { icon = "󰌋", hl = "" },
                    Struct = { icon = "󰌗", hl = "Type" },
                    Operator = { icon = "󰆕", hl = "Operator" },
                    TypeParameter = { icon = "󰊄", hl = "Type" },
                    StaticMethod = { icon = "󰠄 ", hl = "Function" },
                },
            },
        }
    end,
}
