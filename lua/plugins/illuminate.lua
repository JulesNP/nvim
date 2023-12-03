return {
    "RRethy/vim-illuminate",
    event = { "BufRead", "CmdlineLeave", "InsertEnter" },
    keys = vim.g.vscode and {} or {
        {
            "<d-n>",
            function()
                require("illuminate").goto_next_reference(true)
            end,
            desc = "Go to next reference",
        },
        {
            "<d-p>",
            function()
                require("illuminate").goto_prev_reference(true)
            end,
            desc = "Go to previous reference",
        },
    },
    config = function()
        require("illuminate").configure {
            providers = vim.g.vscode and { "treesitter" } or {
                "lsp",
                "treesitter",
            },
            min_count_to_highlight = 2,
            filetype_overrides = {
                sql = {
                    providers = { "regex" },
                },
            },
        }
    end,
}
