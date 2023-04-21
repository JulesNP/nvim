local filetype_settings = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings,
    pattern = { "NeogitCommitMessage", "gitcommit", "html", "markdown", "org", "pug", "text" },
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

vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings,
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove "o"
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { timeout = 300 }
    end,
})

if not vim.g.vscode then
    local sync_view = vim.api.nvim_create_augroup("SyncView", { clear = true })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = sync_view,
        pattern = "?*",
        callback = function()
            if vim.bo.modifiable and vim.bo.filetype ~= "org" then
                vim.cmd "silent! loadview"
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufWinLeave", {
        group = sync_view,
        pattern = "?*",
        callback = function()
            if vim.bo.modifiable and vim.bo.filetype ~= "org" then
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

    vim.api.nvim_create_autocmd("CursorMoved", {
        group = vim.api.nvim_create_augroup("ToggleScrolloff", { clear = true }),
        pattern = "*",
        callback = function()
            if vim.fn.winline() * 2 >= vim.api.nvim_win_get_height(0) then
                vim.o.scrolloff = 0
            else
                local so = 0
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                    local config = vim.api.nvim_win_get_config(win)
                    if config.relative == "win" and config.zindex == 20 then
                        so = config.height
                    end
                end
                vim.o.scrolloff = so
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

    -- Helper funstions to count how many windows being used for actual editing are open
    local function is_essential(filetype)
        return not vim.tbl_contains({ "help", "neo-tree", "qf", "toggleterm" }, filetype)
    end
    local function count_essential(layout)
        if layout[1] == "leaf" then
            local ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype")
            return is_essential(ft) and 1 or 0, ft == "toggleterm" and 1 or 0
        end

        local essential, tterm = 0, 0
        for _, value in ipairs(layout[2]) do
            local e, t = count_essential(value)
            essential = essential + e
            tterm = tterm + t
        end
        return essential, tterm
    end

    -- If the only remaining editing window is being closed, also close all non-essential windows to allow vim to exit gracefully
    vim.api.nvim_create_autocmd("QuitPre", {
        group = vim.api.nvim_create_augroup("GracefulExit", { clear = true }),
        pattern = "*",
        callback = function()
            if not is_essential(vim.bo.filetype) then
                return
            end

            local essential, tterm = count_essential(vim.fn.winlayout())

            if essential ~= 1 then
                return
            end

            vim.cmd.cclose()
            vim.cmd "silent! Neotree close"

            if tterm > 0 then
                vim.cmd "silent! ToggleTermToggleAll!"
            end
        end,
    })
end
