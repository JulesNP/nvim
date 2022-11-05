local filetype_settings = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings,
    pattern = { "NeogitCommitMessage", "gitcommit", "markdown", "org", "text" },
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

vim.api.nvim_create_autocmd("BufEnter", {
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
        vim.cmd "silent! mkview"
    end,
})

local cursorline_toggle = vim.api.nvim_create_augroup("CursorLineInsertToggle", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
    group = cursorline_toggle,
    pattern = "*",
    callback = function()
        vim.cmd.setlocal "nocursorline"
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = cursorline_toggle,
    pattern = "*",
    callback = function()
        vim.cmd.setlocal "cursorline"
    end,
})

local configure_terminal = vim.api.nvim_create_augroup("ConfigureTerminal", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
    group = configure_terminal,
    pattern = "*",
    callback = function()
        vim.cmd.setlocal "nonumber"
        vim.cmd.setlocal "norelativenumber"
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlighYank", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { timeout = 300 }
    end,
})
