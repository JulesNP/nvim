return {
    {
        "nmac427/guess-indent.nvim",
        cond = not vim.g.vscode,
        event = "BufRead",
        ft = { "lazy", "text" },
        config = true,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        cond = not vim.g.vscode,
        event = "BufRead",
        ft = { "lazy", "text" },
        keys = vim.g.vscode and {} or {
            {
                "<leader>ti",
                function()
                    vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
                    vim.cmd "IBLToggle"
                end,
                desc = "Toggle indent guides",
            },
        },
        init = function()
            require("ibl").setup {
                indent = { char = "▏", priority = 15 },
                scope = { enabled = false },
                exclude = {
                    filetypes = {
                        "",
                        "TelescopePrompt",
                        "TelescopeResults",
                        "checkhealth",
                        "dbout",
                        "gitcommit",
                        "help",
                        "lspinfo",
                        "man",
                        "packer",
                    },
                },
            }
        end,
    },
}
