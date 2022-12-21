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

    -- Remove relative numbers via remap of `:` instead of CmdlineEnter to avoid clearing visual selection
    vim.api.nvim_set_keymap("", ":", "<cmd>set nornu<cr>:", { noremap = true, desc = "Enter command-line mode" })

    vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
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

    -- Helper funstions to count how many windows being used for actual editing are open
    local function is_essential(filetype)
        return not vim.tbl_contains({ "help", "neo-tree", "qf", "toggleterm" }, filetype)
    end
    local function count_essential(layout)
        if layout[1] == "leaf" then
            return is_essential(vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype")) and 1 or 0
        end
        local count = 0
        for _, value in ipairs(layout[2]) do
            count = count + count_essential(value)
        end
        return count
    end

    -- If the only remaining editing window is being closed, also close all non-essential windows to allow vim to exit gracefully
    vim.api.nvim_create_autocmd("QuitPre", {
        group = vim.api.nvim_create_augroup("GracefulExit", { clear = true }),
        pattern = "*",
        callback = function()
            if is_essential(vim.bo.filetype) and count_essential(vim.fn.winlayout()) == 1 then
                vim.cmd.cclose()
                vim.cmd "silent! Neotree close"
                vim.cmd "silent! ToggleTermToggleAll!"
            end
        end,
    })
end
