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
        local function hl_from_name(name)
            local hl = vim.api.nvim_get_hl(0, { name = name })
            while hl.link ~= nil do
                hl = vim.api.nvim_get_hl(0, { name = hl.link })
            end
            return {
                bg = hl.bg,
                fg = hl.fg,
                bold = hl.bold,
                italic = hl.italic,
                underline = hl.underline,
            }
        end

        local cursor_line = hl_from_name "CursorLine"
        vim.api.nvim_set_hl(0, "Visual", cursor_line)

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
        vim.api.nvim_set_hl(0, "NeogitDiffAddCursor", { link = "Added" })
        vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { link = "DiffAdd" })
        vim.api.nvim_set_hl(0, "NeogitDiffDelete", { link = "Removed" })
        vim.api.nvim_set_hl(0, "NeogitDiffDeleteCursor", { link = "Removed" })
        vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { link = "DiffDelete" })
        vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = vim.g.terminal_color_12 })
        vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = vim.g.terminal_color_14 })
        vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = vim.g.terminal_color_10 })
        vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = vim.g.terminal_color_2 })
        vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = vim.g.terminal_color_9 })
        vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = vim.g.terminal_color_13 })
        vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = vim.g.terminal_color_11 })

        local line_nr = hl_from_name "LineNr"
        local normal = hl_from_name "Normal"
        local normal_float = hl_from_name "NormalFloat"

        local function diff_bg(name)
            local hl = hl_from_name(name)
            if hl.bg == normal.bg then
                hl.bg = normal_float.bg
            end
            return hl
        end

        vim.api.nvim_set_hl(0, "Added", diff_bg "DiffAdd")
        vim.api.nvim_set_hl(0, "Changed", diff_bg "DiffChange")
        vim.api.nvim_set_hl(0, "Removed", diff_bg "DiffDelete")

        local title = hl_from_name "Title"
        title.bg = normal_float.bg
        vim.api.nvim_set_hl(0, "FloatFooter", title)
        vim.api.nvim_set_hl(0, "FloatTitle", title)

        local color_column = hl_from_name "ColorColumn"
        local cursor_line_nr = hl_from_name "CursorLineNr"
        cursor_line_nr.bg = color_column.bg
        vim.api.nvim_set_hl(0, "CursorLineNr", cursor_line_nr)

        line_nr.bg = normal_float.bg
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", line_nr)

        local comment = hl_from_name "Comment"
        comment.italic = true
        vim.api.nvim_set_hl(0, "Comment", comment)

        local match_paren = hl_from_name "MatchParen"
        match_paren.underline = nil
        vim.api.nvim_set_hl(0, "MatchParen", match_paren)
        match_paren.underline = true
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", match_paren)
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
