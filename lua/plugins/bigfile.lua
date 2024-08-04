return {
    "LunarVim/bigfile.nvim",
    event = "VeryLazy",
    opts = {
        features = {
            "indent_blankline",
            "illuminate",
            "lsp",
            "treesitter",
            "syntax",
            "matchparen",
            "vimopts",
            "filetype",
            {
                name = "minimap",
                opts = { defer = false },
                disable = function()
                    vim.g.show_mini_map = false
                    if MiniMap then
                        MiniMap.close()
                    end
                end,
            },
        },
    },
}
