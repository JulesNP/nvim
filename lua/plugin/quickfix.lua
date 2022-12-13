return {
    "itchyny/vim-qfedit",
    requires = "folke/which-key.nvim",
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("QFMappings", { clear = true }),
            pattern = "qf",
            callback = function()
                require("which-key").register({
                    ["<c-v>"] = {
                        [[&splitright ? "\<c-w>\<cr>\<c-w>L\<c-w>p\<c-w>J\<c-w>p" : "\<c-w>\<cr>\<c-w>H\<c-w>p\<c-w>J\<c-w>p"]],
                        "Open item in vertical split",
                        expr = true,
                    },
                    ["<leader>q"] = { "<cmd>cclose<cr>", "Close quickfix list" },
                    ["<tab>"] = { "<cr><c-w>p", "Open item but stay in quickfix list" },
                    ["[["] = { "<cmd>colder<cr>", "Switch to older quickfix list" },
                    ["]]"] = { "<cmd>cnewer<cr>", "Switch to newer quickfix list" },
                    ["{"] = { "<cmd>cpfile<cr><c-w>p", "Move to previous file" },
                    ["}"] = { "<cmd>cnfile<cr><c-w>p", "Move to next file" },
                    o = { "<cr><cmd>cclose<cr>", "Open item and close quickfix list" },
                    q = { "<cmd>cclose<cr>", "Close quickfix list" },
                }, { buffer = 0 })
            end,
        })
    end,
}
