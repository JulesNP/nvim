return {
    "brenoprata10/nvim-highlight-colors",
    cond = not vim.g.vscode,
    event = { "BufRead", "CmdlineEnter", "InsertEnter" },
    opts = {
        enable_tailwind = true,
    },
}
