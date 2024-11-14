return {
    {
        "brianhuster/live-preview.nvim",
        keys = {
            { "<leader>lp", "<cmd>LivePreview pick<cr>", desc = "Pick file for live preview" },
            { "<leader>lo", "<cmd>LivePreview start<cr>", desc = "Open buffer in live preview" },
            { "<leader>lx", "<cmd>LivePreview close<cr>", desc = "Close live preview" },
        },
        opts = {
            autokill = true,
            sync_scroll = true,
            picker = "mini.pick",
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            heading = {
                width = "block",
            },
            code = {
                position = "right",
                language_pad = 1,
                width = "block",
                right_pad = 1,
            },
            sign = {
                enabled = false,
            },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
    },
}
