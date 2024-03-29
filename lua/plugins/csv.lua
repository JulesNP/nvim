return {
    "mechatroner/rainbow_csv",
    cond = not vim.g.vscode,
    ft = { "csv", "tsv" },
    init = function()
        vim.g.rbql_backend_language = "js" ---@diagnostic disable-line: inject-field

        vim.keymap.set(
            "n",
            "<c-left>",
            "get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoLeft<cr>' : '<c-left>'",
            { expr = true }
        )
        vim.keymap.set(
            "n",
            "<c-right>",
            "get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoRight<cr>' : '<c-right>'",
            { expr = true }
        )
        vim.keymap.set("n", "<c-up>", "get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoUp<cr>' : '<c-up>'", { expr = true })
        vim.keymap.set(
            "n",
            "<c-down>",
            "get(b:, 'rbcsv', 0) == 1 ? ':RainbowCellGoDown<cr>' : '<c-down>'",
            { expr = true }
        )
    end,
}
