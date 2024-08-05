return {
    {
        "iamcco/markdown-preview.nvim",
        cond = not vim.g.vscode,
        keys = vim.g.vscode and {} or {
            { "<leader>p", "<Plug>MarkdownPreviewToggle", desc = "Toggle Markdown Preview" },
        },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            headings = {
                shift_width = 1,
            },
        },
    },
}
