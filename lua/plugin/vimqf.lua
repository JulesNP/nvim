return {
    "romainl/vim-qf",
    requires = "folke/which-key.nvim",
    config = function()
        local wk = require "which-key"
        wk.register {
            ["[q"] = { "<plug>(qf_qf_previous)", "Next quickfix item" },
            ["]q"] = { "<plug>(qf_qf_next)", "Next quickfix item" },
        }

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("QFMappings", { clear = true }),
            pattern = "qf",
            callback = function()
                wk.register({
                    ["<c-v>"] = {
                        [[&splitright ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p" : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"]],
                        "Open item in vertical split",
                        expr = true,
                    },
                    ["<leader>q"] = { "<cmd>cclose<CR>", "Close quickfix list" },
                    ["<tab>"] = { "<CR><C-w>p", "Open item but stay in quickfix list" },
                    ["[["] = { "<plug>(qf_older)", "Switch to older quickfix list" },
                    ["]]"] = { "<plug>(qf_newer)", "Switch to newer quickfix list" },
                    ["{"] = { "<plug>(qf_previous_file)", "Move to previous file" },
                    ["}"] = { "<plug>(qf_next_file)", "Move to next file" },
                    d = { ":<c-u>'<,'>Reject<cr>", "Remove selected items from list", mode = "v" },
                    dd = { "<cmd>.Reject<cr>", "Remove item from list" },
                    df = { "<cmd>Reject<cr>", "Remove file from list" },
                    o = { "<CR><cmd>cclose<CR>", "Open item and close quickfix list" },
                    q = { "<cmd>cclose<CR>", "Close quickfix list" },
                }, { buffer = 0 })
            end,
        })
    end,
}
