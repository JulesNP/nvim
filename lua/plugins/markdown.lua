return {
    "iamcco/markdown-preview.nvim",
    cond = not vim.g.vscode,
    keys = vim.g.vscode and {} or {
        { "<leader>p", "<Plug>MarkdownPreviewToggle", desc = "Toggle Markdown Preview" },
    },
    build = function()
        vim.fn["mkdp#util#install"]()
    end,
}
