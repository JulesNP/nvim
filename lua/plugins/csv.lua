---@diagnostic disable: undefined-field
return {
    "mechatroner/rainbow_csv",
    cond = not vim.g.vscode,
    ft = { "csv", "csv_pipe", "csv_semicolon", "csv_whitespace", "tsv" },
    config = function()
        vim.g.rbql_backend_language = "js" ---@diagnostic disable-line: inject-field

        vim.keymap.set("n", "<F5>", "<cmd>RainbowQuery<cr>", { desc = "RBQL Query" })
        vim.keymap.set("n", "<c-left>", function()
            if vim.b.rbcsv == 1 then
                vim.cmd "RainbowCellGoLeft"
            else
                return "<c-left>"
            end
        end)
        vim.keymap.set("n", "<c-right>", function()
            if vim.b.rbcsv == 1 then
                vim.cmd "RainbowCellGoRight"
            else
                return "<c-right>"
            end
        end)
        vim.keymap.set("n", "<c-up>", function()
            if vim.b.rbcsv == 1 then
                vim.cmd "RainbowCellGoUp"
            else
                return "<c-up>"
            end
        end)
        vim.keymap.set("n", "<c-down>", function()
            if vim.b.rbcsv == 1 then
                vim.cmd "RainbowCellGoDown"
            else
                return "<c-down>"
            end
        end)
    end,
}
