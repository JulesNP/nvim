return {
    "Shatur/neovim-session-manager",
    requires = "nvim-lua/plenary.nvim",
    config = function()
        require("session_manager").setup {
            autosave_ignore_filetypes = {
                "NeogitStatus",
                "NvimTree",
                "gitcommit",
                "toggleterm",
            },
            autosave_ignore_not_normal = false,
        }
    end,
}
