return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
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
