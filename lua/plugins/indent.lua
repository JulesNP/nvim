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
        keys = vim.g.vscode and {} or {
            {
                "<leader>ti",
                function()
                    vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
                    vim.cmd "IndentBlanklineToggle"
                end,
                desc = "Toggle indent guides",
            },
        },
        init = function()
            vim.g.indent_blankline_enabled = false
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("IndentBlanklineEnable", { clear = true }),
                callback = function()
                    if vim.bo.buftype == "" and vim.bo.filetype ~= "toggleterm" and vim.bo.filetype ~= "dbout" then
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
