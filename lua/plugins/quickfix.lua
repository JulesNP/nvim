return {
    "itchyny/vim-qfedit",
    cond = not vim.g.vscode,
    ft = "qf",
    dependencies = "folke/which-key.nvim",
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("QFMappings", { clear = true }),
            pattern = "qf",
            callback = function()
                require("which-key").register({
                    ["<c-s>"] = { "<c-w><cr><c-w>K", "Open item in horizontal split" },
                    ["<c-v>"] = { "<c-w><cr><c-w>H<c-w>p<c-w>J<c-w>p", "Open item in vertical split" },
                    ["<leader>q"] = { vim.cmd.cclose, "Close quickfix list" },
                    ["<tab>"] = { "<cr><c-w>p", "Open item but stay in quickfix list" },
                    ["[["] = {
                        function()
                            pcall(vim.cmd.colder)
                        end,
                        "Switch to older quickfix list",
                    },
                    ["]]"] = {
                        function()
                            pcall(vim.cmd.cnewer)
                        end,
                        "Switch to newer quickfix list",
                    },
                    ["{"] = { "<cmd>cpfile<cr><c-w>p", "Move to previous file" },
                    ["}"] = { "<cmd>cnfile<cr><c-w>p", "Move to next file" },
                    o = { "<cr><cmd>cclose<cr>", "Open item and close quickfix list" },
                    q = { vim.cmd.cclose, "Close quickfix list" },
                }, { buffer = 0 })
            end,
        })
    end,
}
