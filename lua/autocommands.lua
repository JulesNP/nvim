---@diagnostic disable: undefined-field
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
    pattern = "dbui",
    callback = function()
        vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Go to the down window", buffer = 0 })
        vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Go to the up window", buffer = 0 })
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ColorScheme", { clear = true }),
    callback = function()
        local function hl_from_name(hl_name)
            local hl_info = vim.api.nvim_get_hl(0, { name = hl_name })
            return {
                link = hl_info.link,
                bg = hl_info.bg,
                fg = hl_info.fg,
                bold = hl_info.bold,
                italic = hl_info.italic,
                underline = hl_info.underline,
                ctermbg = hl_info.ctermbg,
                ctermfg = hl_info.ctermfg,
            }
        end

        vim.api.nvim_set_hl(0, "CursorLine", { link = "ColorColumn" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticFloatingError" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticFloatingHint" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticFloatingInfo" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk", { link = "DiagnosticFloatingOk" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticFloatingWarn" })
        vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true, underline = true })
        vim.api.nvim_set_hl(0, "EyelinerSecondary", { bold = true })
        vim.api.nvim_set_hl(0, "FlashLabel", { link = "RedrawDebugRecompose" })
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "PmenuExtra" })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "MatchWord" })
        vim.api.nvim_set_hl(0, "IlluminatedWordText", { link = "MatchWord" })
        vim.api.nvim_set_hl(0, "NeogitDiffAdd", { link = "Added" })
        vim.api.nvim_set_hl(0, "NeogitDiffAddCursor", { link = "Removed" })
        vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { link = "DiffAdd" })
        vim.api.nvim_set_hl(0, "NeogitDiffDelete", { link = "Removed" })
        vim.api.nvim_set_hl(0, "NeogitDiffDeleteCursor", { link = "Removed" })
        vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { link = "DiffDelete" })

        local pmenu = vim.api.nvim_get_hl(0, { name = "Pmenu" })

        local diff_add = hl_from_name "DiffAdd"
        diff_add.bg = pmenu.bg
        vim.api.nvim_set_hl(0, "Added", diff_add)

        local diff_change = hl_from_name "DiffChange"
        diff_change.bg = pmenu.bg
        vim.api.nvim_set_hl(0, "Changed", diff_change)

        local diff_delete = hl_from_name "DiffDelete"
        diff_delete.bg = pmenu.bg
        vim.api.nvim_set_hl(0, "Removed", diff_delete)

        local title = hl_from_name "Title"
        title.bg = pmenu.bg
        vim.api.nvim_set_hl(0, "FloatFooter", title)
        vim.api.nvim_set_hl(0, "FloatTitle", title)

        local color_column = hl_from_name "ColorColumn"
        local cursor_line_nr = hl_from_name "CursorLineNr"
        cursor_line_nr.bg = color_column.bg
        vim.api.nvim_set_hl(0, "CursorLineNr", cursor_line_nr)

        local line_nr = hl_from_name "LineNr"
        line_nr.bg = pmenu.bg
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", line_nr)

        local comment = hl_from_name "Comment"
        comment.italic = true
        vim.api.nvim_set_hl(0, "Comment", comment)

        local match_paren = hl_from_name "MatchParen"
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", match_paren)
        match_paren.underline = nil
        vim.api.nvim_set_hl(0, "MatchParen", match_paren)
        match_paren.bold = nil
        vim.api.nvim_set_hl(0, "Visual", match_paren)
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
    callback = function()
        vim.highlight.on_yank { timeout = 300 }
    end,
})

if not vim.g.vscode then
    local sync_view = vim.api.nvim_create_augroup("SyncView", { clear = true })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = sync_view,
        callback = function()
            if vim.bo.modifiable and vim.bo.filetype ~= "org" then
                vim.cmd "silent! loadview"
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufWinLeave", {
        group = sync_view,
        callback = function()
            if vim.bo.modifiable and vim.bo.filetype ~= "org" then
                vim.cmd "silent! mkview"
            end
        end,
    })

    local cursor_line_toggle = vim.api.nvim_create_augroup("CursorLineToggle", { clear = true })

    vim.api.nvim_create_autocmd({ "WinLeave" }, {
        group = cursor_line_toggle,
        callback = function()
            vim.wo.cursorline = false
        end,
    })

    vim.api.nvim_create_autocmd({ "WinEnter" }, {
        group = cursor_line_toggle,
        callback = function()
            vim.wo.cursorline = true
        end,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "WinScrolled" }, {
        group = vim.api.nvim_create_augroup("ToggleScrolloff", { clear = true }),
        callback = function()
            local scrolloff = 0
            if vim.fn.winline() * 2 < vim.api.nvim_win_get_height(0) then
                scrolloff = require "context-height"()
            end
            if scrolloff ~= vim.o.scrolloff then
                vim.o.scrolloff = scrolloff
            end
        end,
    })

    vim.api.nvim_create_autocmd("TermOpen", {
        group = vim.api.nvim_create_augroup("ConfigureTerminal", { clear = true }),
        callback = function()
            vim.cmd.setlocal "nonumber"
            vim.cmd.setlocal "norelativenumber"
        end,
    })

    -- Helper funstions to count how many windows being used for actual editing are open
    local function is_essential(filetype)
        return not vim.tbl_contains({ "help", "qf", "toggleterm" }, filetype)
    end
    local function count_essential(layout)
        if layout[1] == "leaf" then
            local ft = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(layout[2]) })
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
        callback = function()
            if not is_essential(vim.bo.filetype) then
                return
            end

            local essential, tterm = count_essential(vim.fn.winlayout())

            if essential ~= 1 then
                return
            end

            vim.cmd.cclose()

            if tterm > 0 then
                vim.cmd "silent! ToggleTermToggleAll!"
            end
        end,
    })
end
