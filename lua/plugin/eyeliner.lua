return {
    "jinh0/eyeliner.nvim",
    config = function()
        require("eyeliner").setup {
            highlight_on_key = true,
        }
        vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true, underline = true })
        vim.api.nvim_set_hl(0, "EyelinerSecondary", { bold = true })
    end,
}
