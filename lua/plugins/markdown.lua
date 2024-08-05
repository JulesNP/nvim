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
        },
        opts = {
            headings = {
                shift_width = 1,
                heading_1 = { sign = "" },
                heading_2 = { sign = "" },
            },
            code_blocks = { sign = false },
        },
    },
}
