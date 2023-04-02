return {
    {
        "nmac427/guess-indent.nvim",
        cond = not vim.g.vscode,
        event = "BufReadPre",
        ft = { "lazy", "markdown" },
        config = true,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        cond = not vim.g.vscode,
        event = "BufReadPre",
        ft = { "lazy", "markdown" },
        opts = {
            char = "▏",
        },
    },
}
