return {
    "mechatroner/rainbow_csv",
    cond = not vim.g.vscode,
    ft = { "csv", "tsv" },
    config = function()
        vim.g.rbql_backend_language = "js"
    end,
}
