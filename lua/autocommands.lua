local filetype_settings = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings,
    pattern = { "NeogitCommitMessage", "gitcommit", "markdown", "org", "text" },
    callback = function()
        vim.cmd.setlocal "spell"
    end,
})

if not vim.g.vscode then
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
        pattern = "?*",
        callback = function()
            if vim.bo.filetype ~= "org" then
                vim.cmd "silent! loadview"
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufWinLeave", {
        group = sync_view,
        pattern = "?*",
        callback = function()
            if vim.bo.filetype ~= "org" then
                vim.cmd "silent! mkview"
            end
        end,
    })

    local relative_number_toggle = vim.api.nvim_create_augroup("RelativeNumberToggle", { clear = true })

    vim.api.nvim_create_autocmd({ "BufLeave", "CmdlineEnter", "FocusLost", "InsertEnter", "WinLeave" }, {
        group = relative_number_toggle,
        pattern = "*",
        callback = function()
            if vim.o.number then
                vim.o.relativenumber = false
                vim.cmd.redraw()
            end
        end,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "CmdlineLeave", "FocusGained", "InsertLeave", "WinEnter" }, {
        group = relative_number_toggle,
        pattern = "*",
        callback = function()
            if vim.o.number then
                vim.o.relativenumber = true
            end
        end,
    })

    vim.api.nvim_create_autocmd("TermOpen", {
        group = vim.api.nvim_create_augroup("ConfigureTerminal", { clear = true }),
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
end
