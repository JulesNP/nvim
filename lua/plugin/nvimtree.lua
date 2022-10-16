return {
    "kyazdani42/nvim-tree.lua",
    requires = {
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
        }
        require("which-key").register {
            ["<c-n>"] = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
        }
    end,
}
