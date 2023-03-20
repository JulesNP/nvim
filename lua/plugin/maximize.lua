return {
    "caenrique/nvim-maximize-window-toggle",
    dependencies = "folke/which-key.nvim",
    config = function()
        require("which-key").register { ["<leader>z"] = { "<cmd>ToggleOnly<Enter>", "Maximize/restore window" } }
    end,
}
