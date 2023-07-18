return {
    "iamcco/markdown-preview.nvim",
    cond = not vim.g.vscode,
    ft = "markdown",
    keys = vim.g.vscode and {} or {
        { "<c-p>", "<Plug>MarkdownPreviewToggle", desc = "Toggle Markdown Preview" },
    },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
}
