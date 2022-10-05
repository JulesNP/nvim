return {
    "Shatur/neovim-session-manager",
    requires = "nvim-lua/plenary.nvim",
    config = function()
        require("session_manager").setup {
            autosave_ignore_filetypes = {
                "NeogitStatus",
                "NvimTree",
                "gitcommit",
                "packer",
                "toggleterm",
            },
            autosave_ignore_not_normal = false,
        }
        require("which-key").register {
            ["<leader>ss"] = { "<cmd>SessionManager load_session<cr>", "Select session" },
        }
    end,
}
