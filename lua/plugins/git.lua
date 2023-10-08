return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            "tpope/vim-rhubarb",
        },
        cond = not vim.g.vscode,
        event = "CmdlineEnter",
        keys = vim.g.vscode and {} or {
            { "<leader>gP", "<cmd>Git push<cr>", desc = "Push" },
            { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
            { "<leader>gp", "<cmd>Git pull<cr>", desc = "Pull" },
        },
    },
    {
        "NeogitOrg/neogit",
        cond = not vim.g.vscode,
        keys = vim.g.vscode and {} or {
            { "<leader>gg", "<cmd>Neogit<cr>", desc = "Open Neogit" },
            {
                "<leader>g-",
                function()
                    local cwd = vim.fn.expand "%:p:h"
                    require("neogit").open {}
                    vim.cmd(":lcd" .. cwd)
                end,
                desc = "Open Neogit for current buffer",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
        },
        opts = {
            disable_commit_confirmation = true,
            disable_insert_on_commit = false,
            integrations = {
                telescope = true,
                diffview = true,
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        cond = not vim.g.vscode,
        event = "BufRead",
        ft = "markdown",
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
                -- map("n", "[c", function()
                --     if vim.wo.diff then
                --         return "[c"
                --     end
                --     vim.schedule(function()
                --         gs.prev_hunk()
                --     end)
                --     return "<Ignore>"
                -- end, "Prev hunk")
                -- map("n", "]c", function()
                --     if vim.wo.diff then
                --         return "]c"
                --     end
                --     vim.schedule(function()
                --         gs.next_hunk()
                --     end)
                --     return "<Ignore>"
                -- end, "Next hunk")
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
                border = "none",
                row = 1,
            },
        },
    },
}
