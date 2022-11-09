return {
    "Shatur/neovim-session-manager",
    requires = { "folke/which-key.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        require("session_manager").setup {
            autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
            autosave_ignore_dirs = {
                "~",
                "~\\Documents\\Projects",
            },
        }
        require("which-key").register {
            ["<leader>s"] = {
                name = "session",
                cd = { "<cmd>SessionManager load_current_dir_session<cr>", "Load session from current directory" },
                d = { "<cmd>SessionManager delete_session<cr>", "Delete session" },
                s = { "<cmd>SessionManager load_session<cr>", "Select session" },
                w = { "<cmd>SessionManager save_current_session<cr>", "Save current session" },
            },
        }

        local session_loading = vim.api.nvim_create_augroup("SessionLoading", { clear = true })

        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "SessionLoadPre",
            group = session_loading,
            callback = function()
                vim.cmd "silent! Neotree close"
            end,
        })
    end,
}
