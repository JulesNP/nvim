return {
    "JulesNP/neovim-session-manager",
    branch = "filter",
    requires = "nvim-lua/plenary.nvim",
    config = function()
        require("session_manager").setup {
            autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
            autosave_ignore_filetypes = {
                "NeogitCommitView",
                "NeogitStatus",
                "NvimTree",
                "gitcommit",
                "packer",
                "toggleterm",
            },
            autosave_ignore_dirs = {
                "~",
                "~/.config",
            },
            autosave_ignore_not_normal = false,
        }
        require("which-key").register {
            ["<leader>s"] = {
                name = "session",
                cd = { "<cmd>SessionManager load_current_dir_session<cr>", "Load session from current directory" },
                d = { "<cmd>SessionManager delete_session<cr>", "Delete session" },
                s = { "<cmd>SessionManager load_session<cr>", "Select session" },
            },
        }
    end,
}
