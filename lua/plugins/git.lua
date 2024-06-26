return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
        },
        cond = not vim.g.vscode,
        event = { "BufRead", "CmdlineEnter" },
        keys = vim.g.vscode and {} or {
            { "<leader>gP", "<cmd>Git push<cr>", desc = "Push" },
            { "<leader>gC", "<cmd>Git commit<cr>", desc = "New commit" },
            { "<leader>gp", "<cmd>Git pull<cr>", desc = "Pull" },
        },
    },
    {
        "NeogitOrg/neogit",
        tag = vim.fn.has "nvim-0.10" == 1 and "v1.0.0" or "v0.0.1",
        cond = not vim.g.vscode,
        keys = vim.g.vscode and {} or {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        opts = {
            disable_commit_confirmation = true,
            disable_insert_on_commit = false,
            integrations = {
                diffview = true,
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        cond = not vim.g.vscode,
        event = { "BufRead", "BufWrite", "CmdlineEnter" },
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local function map(mode, key, func, desc)
                    vim.keymap.set(mode, key, func, { desc = desc, buffer = bufnr })
                end
                map("n", "<leader>hD", function()
                    gs.diffthis "~"
                end, "Git diff~")
                map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
                map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>hb", function()
                    gs.blame_line { full = true }
                end, "Blame line")
                map("n", "<leader>hd", gs.diffthis, "Git diff")
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hq", "<cmd>Gitsigns setqflist 'all'<cr>", "List all hunks")
                map("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk")
                map("n", "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk")
                map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle current line blame")
                map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted")
                map("n", "[h", gs.prev_hunk, "Prev hunk")
                map("n", "]h", gs.next_hunk, "Next hunk")
                map("o", "ah", "<cmd>Gitsigns select_hunk<CR>", "Select hunk")
                map("o", "ih", "<cmd>Gitsigns select_hunk<CR>", "Select hunk")
                map("x", "<leader>hr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
                map("x", "<leader>hs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
                map("x", "ah", ":<c-u>Gitsigns select_hunk<CR>", "Select hunk")
                map("x", "ih", ":<c-u>Gitsigns select_hunk<CR>", "Select hunk")
            end,
            preview_config = {
                border = "rounded",
                row = 1,
            },
        },
    },
}
