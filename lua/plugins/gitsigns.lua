return {
    "lewis6991/gitsigns.nvim",
    cond = not vim.g.vscode,
    event = "BufRead",
    ft = "markdown",
    config = function()
        require("gitsigns").setup {
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
                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, "Prev hunk")
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, "Next hunk")
                map("o", "ih", "<cmd>Gitsigns select_hunk<CR>", "Select hunk")
                map("x", "<leader>hr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
                map("x", "<leader>hs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
                map("x", "ih", ":<c-u>Gitsigns select_hunk<CR>", "Select hunk")
            end,
            preview_config = {
                border = "none",
                row = 1,
            },
        }
    end,
}
