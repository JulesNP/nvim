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
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            heading = {
                width = "block",
            },
            code = {
                width = "block",
            },
            sign = {
                enabled = false,
            },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    },
}
