vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.*",
    callback = function()
        vim.cmd "silent! loadview"
    end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*.*",
    callback = function()
        vim.cmd "mkview"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "NeogitCommitMessage", "gitcommit", "markdown", "text" },
    callback = function()
        vim.cmd "setlocal spell"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.opt_local.suffixesadd:prepend ".lua"
        vim.opt_local.suffixesadd:prepend "init.lua"
        vim.opt_local.path:prepend(vim.fn.stdpath "config" .. "/lua")
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { timeout = 300 }
    end,
})
