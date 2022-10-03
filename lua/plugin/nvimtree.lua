return {
    "kyazdani42/nvim-tree.lua",
    requires = {
        "kyazdani42/nvim-web-devicons",
    },
    tag = "nightly",
    config = function()
        require("nvim-tree").setup {
            filters = {
                custom = { "^.git$" },
            },
        }
        require("which-key").register {
            ["<c-n>"] = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
        }
    end,
}
