return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                require("which-key").register {
                    ["]c"] = {
                        function()
                            if vim.wo.diff then
                                return "]c"
                            end
                            vim.schedule(function()
                                gs.next_hunk()
                            end)
                            return "<Ignore>"
                        end,
                        "Next hunk",
                    },
                    ["[c"] = {
                        function()
                            if vim.wo.diff then
                                return "[c"
                            end
                            vim.schedule(function()
                                gs.prev_hunk()
                            end)
                            return "<Ignore>"
                        end,
                        "Prev hunk",
                    },
                    ["<leader>h"] = {
                        name = "hunk",
                        D = {
                            function()
                                gs.diffthis "~"
                            end,
                            "Git diff~",
                            buffer = bufnr,
                        },
                        R = { gs.reset_buffer, "Reset buffer", buffer = bufnr },
                        S = { gs.stage_buffer, "Stage buffer", buffer = bufnr },
                        b = {
                            function()
                                gs.blame_line { full = true }
                            end,
                            "Blame line",
                            buffer = bufnr,
                        },
                        d = { gs.diffthis, "Git diff", buffer = bufnr },
                        p = { gs.preview_hunk, "Preview hunk", buffer = bufnr },
                        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk", buffer = bufnr },
                        s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk", buffer = bufnr },
                        u = { gs.undo_stage_hunk, "Undo stage hunk", buffer = bufnr },
                    },
                    ["<leader>t"] = {
                        name = "toggle",
                        b = { gs.toggle_current_line_blame, "Toggle current line blame", buffer = bufnr },
                        d = { gs.toggle_deleted, "Toggle deleted", buffer = bufnr },
                    },
                    i = {
                        h = { ":<C-U>Gitsigns select_hunk<CR>", "Select hunk", mode = "o" },
                    },
                    ih = { ":<C-U>Gitsigns select_hunk<CR>", "Select hunk", mode = "x" },
                    ["<leader>hr"] = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk", buffer = bufnr, mode = "v" },
                    ["<leader>hs"] = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk", buffer = bufnr, mode = "v" },
                }
            end,
        }
    end,
}
