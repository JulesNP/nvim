return {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = vim.g.vscode and {} or {
        { "<leader>ee", "<Plug>RestNvim", desc = "Run HTTP request" },
        { "<leader>ep", "<Plug>RestNvimPreview", desc = "Preview HTTP request" },
        { "<leader>er", "<Plug>RestNvimLast", desc = "Repeat HTTP request" },
    },
    config = {
        result = {
            formatters = {
                html = function(body)
                    return vim.fn.system({ "prettier", "--parser", "html" }, body)
                end,
            },
        },
    },
}
