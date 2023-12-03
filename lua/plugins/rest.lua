local function run(action)
    if vim.bo.filetype == "" then
        vim.bo.filetype = "http"
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(action, true, false, true), "n", false)
end

return {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = vim.g.vscode and {} or {
        {
            "<leader>ee",
            function()
                run "<plug>RestNvim"
            end,
            desc = "Run HTTP request",
        },
        {
            "<leader>ep",
            function()
                run "<plug>RestNvimPreview"
            end,
            desc = "Preview HTTP request",
        },
        {
            "<leader>er",
            function()
                run "<plug>RestNvimLast"
            end,
            desc = "Repeat HTTP request",
        },
    },
    opts = {
        result = {
            formatters = {
                html = function(body)
                    if vim.fn.executable "prettier" == 1 then
                        return vim.fn.system({ "prettier", "--parser", "html" }, body)
                    else
                        return body
                    end
                end,
                json = function(body)
                    if vim.fn.executable "prettier" == 1 then
                        return vim.fn.system({ "prettier", "--parser", "json" }, body)
                    else
                        return body
                    end
                end,
            },
        },
    },
}
