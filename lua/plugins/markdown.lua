return {
    {
        "brianhuster/live-preview.nvim",
        keys = {
            { "<leader>lp", "<cmd>LivePreview<cr>", desc = "Enable live preview" },
            { "<leader>lx", "<cmd>StopPreview<cr>", desc = "Stop live preview" },
        },
        opts = {
            sync_scroll = true,
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
