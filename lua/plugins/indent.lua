return {
    {
        "nmac427/guess-indent.nvim",
        cond = not vim.g.vscode,
        event = { "BufRead", "BufWrite" },
        cmd = "GuessIndent",
        config = true,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "▏" },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "",
                    "checkhealth",
                    "dbout",
                    "gitcommit",
                    "help",
                    "lspinfo",
                    "man",
                    "markdown",
                },
            },
        },
    },
}
