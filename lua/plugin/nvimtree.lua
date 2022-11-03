return {
    "kyazdani42/nvim-tree.lua",
    requires = {
        "folke/which-key.nvim",
        "kyazdani42/nvim-web-devicons",
    },
    tag = "nightly",
    config = function()
        require("nvim-tree").setup {
            diagnostics = {
                enable = true,
                icons = {
                    hint = "",
                },
            },
            filters = {
                custom = { "^.git$" },
            },
            reload_on_bufenter = true,
            sync_root_with_cwd = true,
            update_focused_file = {
                enable = true,
            },
            renderer = {
                icons = {
                    git_placement = "after",
                    glyphs = {
                        git = {
                            unstaged = "!",
                            staged = "+",
                            unmerged = "~",
                            renamed = "->",
                            untracked = "?",
                            deleted = "-",
                            ignored = ".",
                        },
                    },
                },
            },
        }
        require("which-key").register {
            ["<c-n>"] = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
        }

        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
            pattern = "NvimTree_*",
            callback = function()
                local layout = vim.api.nvim_call_function("winlayout", {})
                if
                    layout[1] == "leaf"
                    and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
                    and layout[3] == nil
                then
                    vim.cmd "confirm quit"
                end
            end,
        })
    end,
}
