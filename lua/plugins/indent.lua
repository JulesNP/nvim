return {
    "nmac427/guess-indent.nvim",
    cond = not vim.g.vscode,
    event = { "BufRead", "BufWrite" },
    cmd = "GuessIndent",
    config = true,
}
