return {
    "mechatroner/rainbow_csv",
    enabled = not vim.g.vscode,
    config = function()
        vim.g.rbql_backend_language = "js"
    end,
}
