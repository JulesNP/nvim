return {
    {
        "nmac427/guess-indent.nvim",
        cond = not vim.g.vscode,
        event = "BufRead",
        ft = { "lazy", "markdown" },
        config = true,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        cond = not vim.g.vscode,
        event = "BufRead",
        ft = { "lazy", "markdown" },
        init = function()
            vim.g.indent_blankline_enabled = false
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("IndentBlanklineEnable", { clear = true }),
                callback = function()
                    if vim.bo.buftype == "" and vim.bo.filetype ~= "toggleterm" then
                        vim.b.indent_blankline_enabled = true
                    end
                end,
            })
        end,
        opts = {
            char = "▏",
            char_priority = 15,
            show_trailing_blankline_indent = false,
        },
    },
}
