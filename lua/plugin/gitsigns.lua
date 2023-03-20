return {
    "lewis6991/gitsigns.nvim",
    enabled = not vim.g.vscode,
    dependencies = "folke/which-key.nvim",
    config = function()
        require("gitsigns").setup {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local wk = require "which-key"
                wk.register({
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
                        },
                        R = { gs.reset_buffer, "Reset buffer" },
                        S = { gs.stage_buffer, "Stage buffer" },
                        b = {
                            function()
                                gs.blame_line { full = true }
                            end,
                            "Blame line",
                        },
                        d = { gs.diffthis, "Git diff" },
                        p = { gs.preview_hunk, "Preview hunk" },
                        q = { "<cmd>Gitsigns setqflist 'all'<cr>", "List all hunks" },
                        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
                        s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk" },
                        u = { gs.undo_stage_hunk, "Undo stage hunk" },
                    },
                    ["<leader>t"] = {
                        name = "toggle",
                        b = { gs.toggle_current_line_blame, "Toggle current line blame" },
                        d = { gs.toggle_deleted, "Toggle deleted" },
                    },
                    ih = { "<cmd>Gitsigns select_hunk<CR>", "Select hunk", mode = "o" },
                }, { buffer = bufnr })
                wk.register({
                    ih = { ":<c-u>Gitsigns select_hunk<CR>", "Select hunk" },
                    ["<leader>hr"] = { ":Gitsigns reset_hunk<cr>", "Reset hunk" },
                    ["<leader>hs"] = { ":Gitsigns stage_hunk<cr>", "Stage hunk" },
                }, { buffer = bufnr, mode = "x" })
            end,
            preview_config = {
                border = "none",
                row = 1,
            },
        }
    end,
}
