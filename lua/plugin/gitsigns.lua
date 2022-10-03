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
                        "next hunk",
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
                        "prev hunk",
                    },
                    ["<leader>h"] = {
                        name = "hunk",
                        D = {
                            function()
                                gs.diffthis "~"
                            end,
                            'diffthis("~")',
                            buffer = bufnr,
                        },
                        R = { gs.reset_buffer, "reset buffer", buffer = bufnr },
                        S = { gs.stage_buffer, "stage buffer", buffer = bufnr },
                        b = {
                            function()
                                gs.blame_line { full = true }
                            end,
                            "blame line",
                            buffer = bufnr,
                        },
                        d = { gs.diffthis, "diffthis", buffer = bufnr },
                        p = { gs.preview_hunk, "preview hunk", buffer = bufnr },
                        r = { "<cmd>Gitsigns reset_hunk<cr>", "reset hunk", buffer = bufnr },
                        s = { "<cmd>Gitsigns stage_hunk<cr>", "stage hunk", buffer = bufnr },
                        u = { gs.undo_stage_hunk, "undo stage hunk", buffer = bufnr },
                    },
                    ["<leader>t"] = {
                        name = "toggle",
                        b = { gs.toggle_current_line_blame, "toggle current line blame", buffer = bufnr },
                        d = { gs.toggle_deleted, "toggle deleted", buffer = bufnr },
                    },
                    i = {
                        h = { ":<C-U>Gitsigns select_hunk<CR>", "select hunk", mode = "o" },
                    },
                    ih = { ":<C-U>Gitsigns select_hunk<CR>", "select hunk", mode = "x" },
                    ["<leader>hr"] = { "<cmd>Gitsigns reset_hunk<cr>", "reset hunk", buffer = bufnr, mode = "v" },
                    ["<leader>hs"] = { "<cmd>Gitsigns stage_hunk<cr>", "stage hunk", buffer = bufnr, mode = "v" },
                }
            end,
        }
    end,
}
