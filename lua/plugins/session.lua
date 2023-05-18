return {
    "Shatur/neovim-session-manager",
    cond = not vim.g.vscode,
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
        require("session_manager").setup {
            autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
            autosave_ignore_dirs = {
                "/",
                "~",
                "~\\Documents\\Projects",
            },
            autosave_ignore_filetypes = {
                "gitcommit",
                "toggleterm",
            },
        }

        vim.keymap.set("n", "<leader>sx", "<cmd>cd ~|%bd|Alpha<cr>", { desc = "Clear session" })

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
