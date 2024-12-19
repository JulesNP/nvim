return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
        { "<leader>gl", "<cmd>lua Snacks.git.blame_line()<cr>", desc = "Blame line" },
        { "<leader>gx", "<cmd>lua Snacks.gitbrowse()<cr>", desc = "Open git file in browser" },
        {
            "<leader>ti",
            "<cmd>lua if Snacks.indent.enabled then Snacks.indent.disable() else Snacks.indent.enable() end<cr>",
            desc = "Toggle indent guides",
        },
    },
    opts = {
        bigfile = { enabled = true },
        indent = {
            indent = {
                char = "▏",
            },
            scope = {
                enabled = false,
            },
        },
        quickfile = { enabled = true },
    },
}
