local filetype_settings = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings,
    pattern = { "NeogitCommitMessage", "gitcommit", "markdown", "text" },
    callback = function()
        vim.cmd.setlocal "spell"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings,
    pattern = "lua",
    callback = function()
        vim.opt_local.suffixesadd:prepend ".lua"
        vim.opt_local.suffixesadd:prepend "init.lua"
        vim.opt_local.path:prepend(vim.fn.stdpath "config" .. "/lua")
    end,
})

local sync_view = vim.api.nvim_create_augroup("SyncView", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = sync_view,
    pattern = "*.*",
    callback = function()
        vim.cmd "silent! loadview"
    end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
    group = sync_view,
    pattern = "*.*",
    callback = function()
        vim.cmd "mkview"
    end,
})

local augroup_id = vim.api.nvim_create_augroup("CursorLineInsertToggle", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    group = augroup_id,
    pattern = "*",
    callback = function()
        vim.cmd.setlocal "nocursorline"
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = augroup_id,
    pattern = "*",
    callback = function()
        vim.cmd.setlocal "cursorline"
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlighYank", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { timeout = 300 }
    end,
})
