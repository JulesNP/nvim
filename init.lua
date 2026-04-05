-- Plugins {{{
vim.pack.add {
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range "1.x" },
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/GustavEikaas/easy-dotnet.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/ellisonleao/gruvbox.nvim",
    "https://github.com/zapling/mason-conform.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/neogitorg/neogit",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/stevearc/quicker.nvim",
    "https://github.com/mechatroner/rainbow_csv",
    "https://github.com/folke/snacks.nvim",
    { src = "https://github.com/altermo/ultimate-autopair.nvim", version = "v0.6" },
    "https://github.com/tpope/vim-abolish",
    "https://github.com/tpope/vim-rsi",
}
-- }}}

-- Settings {{{
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.conceallevel = 2
vim.o.confirm = true
vim.opt.diffopt:append { algorithm = "histogram" }
vim.o.expandtab = true
vim.o.foldlevel = 99
vim.o.foldtext = ""
vim.o.inccommand = "split"
vim.o.shiftwidth = 4
vim.o.signcolumn = "number"
vim.o.spelllang = "en_ca,en"
vim.o.spelloptions = "camel,noplainbuffer"
vim.o.startofline = true
vim.o.whichwrap = "b,s,<,>,[,]"
if vim.uv.os_uname().sysname == "Windows_NT" then
    vim.o.shellslash = true
    vim.cmd [[
       set noshelltemp
       let &shell = 'pwsh'
       let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
       let &shellcmdflag .= '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
       let &shellcmdflag .= '$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
       let &shellpipe  = '> %s 2>&1'
       set shellquote= shellxquote=
       let &shellcmdflag .= '$PSStyle.OutputRendering = ''PlainText'';'
       " Workaround (may not be needed in future version of pwsh):
       let $__SuppressAnsiEscapeSequences = 1
    ]]
end
-- }}}

-- Autocommands {{{
vim.api.nvim_create_autocmd("FileType", {
    callback = function(event)
        local ok = pcall(vim.treesitter.start)
        if ok then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
        if event.match == "fsharp" then
            vim.bo.commentstring = "// %s"
        elseif event.match == "diff" or event.match == "git" then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.MiniGit.diff_foldexpr()"
        elseif event.match == "lua" then
            vim.opt.formatoptions:remove "o"
        elseif event.match == "qf" then
            vim.keymap.set("n", "<tab>", "<cr><c-w>p", { buffer = 0, desc = "Open but stay in quickfix list" })
            vim.keymap.set("n", "{", "<cmd>cpfile<cr><c-w>p", { buffer = 0, desc = "Move to previous file" })
            vim.keymap.set("n", "}", "<cmd>cnfile<cr><c-w>p", { buffer = 0, desc = "Move to next file" })
            vim.keymap.set("n", "o", "<cr><cmd>cclose<cr>", { buffer = 0, desc = "Open and close quickfix list" })
        elseif event.match == "sql" then
            vim.bo.commentstring = "-- %s"
        end
    end,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*.*",
    callback = function()
        if vim.bo.buftype == "" then
            vim.cmd "silent! mkview"
        end
    end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.*",
    callback = function()
        if vim.bo.buftype == "" then
            vim.cmd "silent! loadview"
        end
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = { "NeogitStatusRefreshed", "NeogitPullComplete", "NeogitStash" },
    command = "checktime",
})
-- }}}

-- Keymaps {{{
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>", { desc = ":help CTRL-L-default" })
vim.keymap.set("n", "<c-s>", "<cmd>silent! mkview<bar>update<cr>", { desc = "Save buffer" })
vim.keymap.set("n", "<m-s>", "<cmd>silent! mkview<bar>wall<cr>", { desc = "Save all buffers" })
vim.keymap.set(
    "n",
    "<leader><c-s>",
    "<cmd>silent! mkview<bar>noautocmd update<cr>",
    { desc = "Save without auto-format" }
)
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "<leader>p", vim.pack.update, { desc = "Update vim.pack" })
vim.keymap.set("t", "<c-h>", "<cmd>wincmd h<cr>")
vim.keymap.set("t", "<c-j>", "<cmd>wincmd j<cr>")
vim.keymap.set("t", "<c-k>", "<cmd>wincmd k<cr>")
vim.keymap.set("t", "<c-l>", "<cmd>wincmd l<cr>")
vim.keymap.set({ "x", "o" }, "<cr>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_parent(vim.v.count1)
    else
        vim.lsp.buf.selection_range(vim.v.count1)
    end
end, { desc = "Select parent (outer) node" })
vim.keymap.set({ "x", "o" }, "<bs>", function()
    if vim.treesitter.get_parser(nil, nil, { error = false }) then
        require("vim.treesitter._select").select_child(vim.v.count1)
    else
        vim.lsp.buf.selection_range(-vim.v.count1)
    end
end, { desc = "Select child (inner) node" })

local function putline(action)
    return function()
        local regName = vim.v.register
        local regType = vim.fn.getregtype(regName)
        if regType ~= "V" then
            local regValue = vim.fn.getreg(regName)
            vim.fn.setreg(regName, regValue, "V")
            vim.cmd("normal! " .. vim.v.count .. '"' .. regName .. action)
            vim.fn.setreg(regName, regValue, regType)
        else
            vim.cmd("normal! " .. vim.v.count .. '"' .. regName .. action)
        end
    end
end
vim.keymap.set("n", "]p", putline "]p", { desc = "Put text after cursor at current indent" })
vim.keymap.set("n", "]P", putline "]P", { desc = "Put text after cursor at current indent" })
vim.keymap.set("n", "[p", putline "[p", { desc = "Put text before cursor at current indent" })
vim.keymap.set("n", "[P", putline "[P", { desc = "Put text before cursor at current indent" })
vim.keymap.set("n", ">p", putline "]p>']", { desc = "Put text after cursor at higher indent" })
vim.keymap.set("n", ">P", putline "[p>']", { desc = "Put text before cursor at higher indent" })
vim.keymap.set("n", "<p", putline "]p<']", { desc = "Put text after cursor at lower indent" })
vim.keymap.set("n", "<P", putline "[p<']", { desc = "Put text before cursor at lower indent" })
vim.keymap.set("n", "=p", putline "]p=']", { desc = "Put text after cursor and reformat" })
vim.keymap.set("n", "=P", putline "[p=']", { desc = "Put text before cursor and reformat" })

vim.keymap.set("n", "<c-left>", function()
    if vim.b.rbcsv == 1 then
        vim.cmd "RainbowCellGoLeft"
    else
        return "<c-left>"
    end
end)
vim.keymap.set("n", "<c-right>", function()
    if vim.b.rbcsv == 1 then
        vim.cmd "RainbowCellGoRight"
    else
        return "<c-right>"
    end
end)
vim.keymap.set("n", "<c-up>", function()
    if vim.b.rbcsv == 1 then
        vim.cmd "RainbowCellGoUp"
    else
        return "<c-up>"
    end
end)
vim.keymap.set("n", "<c-down>", function()
    if vim.b.rbcsv == 1 then
        vim.cmd "RainbowCellGoDown"
    else
        return "<c-down>"
    end
end)

local function toggle_char_eol(character)
    local delimiters = { ",", ";" }
    local mode = vim.api.nvim_get_mode().mode
    local is_visual = mode == "v" or mode == "V" or mode == "\22" -- <C-v>
    if is_visual then
        vim.fn.feedkeys(":", "nx")
    end
    local start_line = is_visual and vim.fn.getpos("'<")[2] or vim.api.nvim_win_get_cursor(0)[1]
    local end_line = is_visual and vim.fn.getpos("'>")[2] or start_line
    for line_idx = start_line, end_line do
        local line = vim.api.nvim_buf_get_lines(0, line_idx - 1, line_idx, false)[1]
        local last_char = line:sub(-1)
        if last_char == character then
            vim.api.nvim_buf_set_lines(0, line_idx - 1, line_idx, false, { line:sub(1, #line - 1) })
        elseif vim.tbl_contains(delimiters, last_char) then
            vim.api.nvim_buf_set_lines(0, line_idx - 1, line_idx, false, { line:sub(1, #line - 1) .. character })
        else
            vim.api.nvim_buf_set_lines(0, line_idx - 1, line_idx, false, { line .. character })
        end
    end
end
vim.keymap.set({ "n", "x" }, "<leader>,", function()
    toggle_char_eol ","
end, { desc = "Toggle ," })
vim.keymap.set({ "n", "x" }, "<leader>;", function()
    toggle_char_eol ";"
end, { desc = "Toggle ;" })
-- }}}

-- Snacks {{{
local Snacks = require "snacks"
Snacks.setup {
    bigfile = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    terminal = { enabled = true },
}
local function terminal_win_options()
    local columns = vim.o.columns
    return {
        position = columns > 160 and "right" or "bottom",
        width = math.max(80, columns / 3),
        height = 0.3,
    }
end
vim.keymap.set({ "n", "t" }, "<c-\\>", function()
    Snacks.terminal.toggle(nil, { win = terminal_win_options() })
end, { desc = "Toggle terminal" })
vim.keymap.set("n", "go", Snacks.picker.lsp_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "gO", Snacks.picker.lsp_workspace_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "z=", Snacks.picker.spelling, { desc = "Show spelling suggestions" })
vim.keymap.set("n", "<leader><leader>", Snacks.picker.smart, { desc = "Find recent file" })
vim.keymap.set("n", "<leader>f<leader>", Snacks.picker.resume, { desc = "Resume last find" })
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers, { desc = "Find buffer" })
vim.keymap.set("n", "<leader>fc", Snacks.picker.colorschemes, { desc = "Find colorscheme" })
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics, { desc = "Find diagnostic" })
vim.keymap.set("n", "<leader>fe", function()
    Snacks.picker.diagnostics { severity = vim.diagnostic.severity.ERROR }
end, { desc = "Find error" })
vim.keymap.set("n", "<leader>ff", Snacks.picker.files, { desc = "Find file" })
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep, { desc = "Find with grep" })
vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "Find help" })
vim.keymap.set("n", "<leader>fH", Snacks.picker.highlights, { desc = "Find highlight" })
vim.keymap.set("n", "<leader>fj", Snacks.picker.jumps, { desc = "Find jump" })
vim.keymap.set("n", "<leader>fk", Snacks.picker.keymaps, { desc = "Find keymap" })
vim.keymap.set("n", "<leader>fm", Snacks.picker.marks, { desc = "Find mark" })
vim.keymap.set("n", "<leader>fo", Snacks.picker.recent, { desc = "Find in :oldfiles" })
vim.keymap.set("n", "<leader>fp", Snacks.picker.projects, { desc = "Find project" })
vim.keymap.set("n", "<leader>fr", Snacks.picker.registers, { desc = "Find register" })
vim.keymap.set({ "n", "x" }, "<leader>fw", Snacks.picker.grep_word, { desc = "Find <word>" })
vim.keymap.set("n", "<leader>x", "<cmd>lua Snacks.bufdelete()<cr>", { desc = "Delete buffer" })
-- }}}

-- mini.nvim {{{
local gen_extra = require("mini.extra").gen_ai_spec
require("mini.ai").setup {
    custom_textobjects = {
        a = require("mini.ai").gen_spec.argument { separator = "[,;]" },
        N = gen_extra.number(),
        d = gen_extra.diagnostic(),
        g = gen_extra.buffer(),
    },
}

require("mini.align").setup {}

require("mini.basics").setup {
    mappings = { basic = false, windows = true },
    autocommands = { relnum_in_visual_mode = true },
}

require("mini.bracketed").setup { indent = { suffix = "" } }
local function set_error_keymap(map, direction)
    vim.keymap.set(
        "n",
        map,
        "<cmd>lua MiniBracketed.diagnostic('" .. direction .. "', { severity = vim.diagnostic.severity.ERROR })<cr>",
        { desc = "Error " .. direction }
    )
end
set_error_keymap("[e", "backward")
set_error_keymap("]e", "forward")
set_error_keymap("[E", "first")
set_error_keymap("]E", "last")

local MiniClue = require "mini.clue"
MiniClue.setup {
    triggers = {
        { mode = { "n", "x" }, keys = "<leader>" },
        { mode = { "n", "x" }, keys = "\\" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "]" },
        { mode = "i", keys = "<C-x>" },
        { mode = { "n", "x" }, keys = "g" },
        { mode = { "n", "x" }, keys = "'" },
        { mode = { "n", "x" }, keys = "`" },
        { mode = { "n", "x" }, keys = '"' },
        { mode = { "i", "c" }, keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = { "n", "x" }, keys = "z" },
    },
    clues = {
        MiniClue.gen_clues.square_brackets(),
        MiniClue.gen_clues.builtin_completion(),
        MiniClue.gen_clues.g(),
        MiniClue.gen_clues.marks(),
        MiniClue.gen_clues.registers(),
        MiniClue.gen_clues.windows(),
        MiniClue.gen_clues.z(),
        { mode = "n", keys = "<leader>f", desc = "+Find" },
        { mode = "n", keys = "<leader>g", desc = "+Git" },
    },
}

require("mini.diff").setup {}
vim.keymap.set("n", "\\o", require("mini.diff").toggle_overlay, { desc = "Tooggle diff overlay" })

local MiniFiles = require "mini.files"
local show_dotfiles = false
local filter_dotfiles = function(fs_entry)
    return show_dotfiles or not vim.startswith(fs_entry.name, ".")
end
MiniFiles.setup {
    content = { filter = filter_dotfiles },
    mappings = {
        go_in = "<tab>",
        go_in_plus = "l",
        go_out_plus = "",
        synchronize = "<c-s>",
    },
}
vim.keymap.set("n", "-", function()
    if vim.bo.buftype == "" then
        MiniFiles.open(vim.fn.expand "%")
    else
        MiniFiles.open(vim.fn.expand "%:h")
    end
end, { desc = "Open Mini Files" })
vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionRename",
    callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set("n", "<leader>a", function()
            local path = vim.fs.dirname(MiniFiles.get_fs_entry().path)
            MiniFiles.close()
            require("easy-dotnet").create_new_item(path)
        end, { buffer = buf_id, desc = "Create file from dotnet template" })
        vim.keymap.set("n", "<m-p>", function()
            MiniFiles.refresh { windows = { preview = true } }
        end, { buffer = buf_id, desc = "Show file previews" })
        vim.keymap.set("n", "<esc>", MiniFiles.close, { buffer = buf_id, desc = "Close" })
        vim.keymap.set("n", "-", MiniFiles.go_out, { buffer = buf_id, desc = "Go out of directory" })
        vim.keymap.set("n", "<c-h>", function()
            show_dotfiles = not show_dotfiles
            MiniFiles.refresh { content = { filter = filter_dotfiles } }
        end, { buffer = buf_id })
        vim.keymap.set("n", "gh", "h", { buffer = buf_id, desc = "Left" })
        vim.keymap.set("n", "gl", "l", { buffer = buf_id, desc = "Right" })
        vim.keymap.set("n", "<c-\\>", function()
            local path = vim.fs.dirname(MiniFiles.get_fs_entry().path)
            Snacks.terminal.open(nil, { cwd = path, win = terminal_win_options() })
        end, { buffer = buf_id, desc = "Open location in terminal" })
        vim.keymap.set("n", "<cr>", function()
            local fs_entry = MiniFiles.get_fs_entry()
            local is_at_file = fs_entry ~= nil and fs_entry.fs_type == "file"
            MiniFiles.go_in {}
            if is_at_file then
                MiniFiles.close()
            end
        end, { buffer = buf_id, desc = "Go in entry" })
        vim.keymap.set("n", "g.", function()
            local path = vim.fs.dirname(MiniFiles.get_fs_entry().path)
            vim.fn.chdir(path)
            vim.notify("CWD set to: " .. path)
        end, { buffer = buf_id, desc = "Set CWD" })
        vim.keymap.set("n", "gx", function()
            local path = MiniFiles.get_fs_entry().path
            vim.ui.open(path)
        end, { buffer = buf_id, desc = "Open filepath with system handler" })
        vim.keymap.set("n", "gy", function()
            local path = MiniFiles.get_fs_entry().path
            vim.fn.setreg(vim.v.register, path)
            vim.notify("Yanked to " .. vim.v.register .. " register: " .. path)
        end, { buffer = buf_id, desc = "Yank filepath" })
    end,
})

require("mini.git").setup {}
vim.keymap.set("n", "<leader>gs", require("mini.git").show_at_cursor, { desc = "Git show_at_cursor" })

require("mini.icons").setup {}

require("mini.indentscope").setup {
    draw = { animation = require("mini.indentscope").gen_animation.none() },
    options = { indent_at_cursor = false },
    symbol = "▏",
}
Snacks.util.set_hl { MiniIndentscopeSymbol = { link = "NonText" } }

require("mini.misc").setup_auto_root()
vim.keymap.set("n", "<leader>z", require("mini.misc").zoom, { desc = "Zoom buffer" })

require("mini.move").setup { options = { reindent_linewise = false } }

local MiniOperators = require "mini.operators"
MiniOperators.setup { exchange = { prefix = "" }, replace = { prefix = "s" } }
MiniOperators.make_mappings("exchange", { textobject = "sx", line = "sxx", selection = "X" })
vim.keymap.set("n", "S", "s$", { remap = true, desc = "Substite to end of line" })
vim.keymap.set("n", "sX", "sx$", { remap = true, desc = "Exchange to end of line" })

local function confirm_discard_changes(all_buffers)
    local buf_list = all_buffers == false and { 0 } or vim.api.nvim_list_bufs()
    local unsaved = vim.tbl_filter(function(buf_id)
        return vim.bo[buf_id].modified and vim.bo[buf_id].buflisted
    end, buf_list)
    if #unsaved == 0 then
        return true
    end
    for _, buf_id in ipairs(unsaved) do
        local name = vim.api.nvim_buf_get_name(buf_id)
        local result = vim.fn.confirm(
            string.format('Save changes to "%s"?', name ~= "" and vim.fn.fnamemodify(name, ":~:.") or "Untitled"),
            "&Yes\n&No\n&Cancel",
            1,
            "Question"
        )
        if result == 1 then
            if buf_id ~= 0 then
                vim.cmd("buffer " .. buf_id)
            end
            vim.cmd "update"
        elseif result == 0 or result == 3 then
            return false
        end
    end
    return true
end
local MiniSessions = require "mini.sessions"
MiniSessions.setup {}
vim.keymap.set("n", "<leader>sd", function()
    MiniSessions.select "delete"
end, { desc = "Delete session" })
vim.keymap.set("n", "<leader>ss", function()
    local items = vim.tbl_values(MiniSessions.detected)
    local current = vim.fn.fnamemodify(vim.v.this_session, ":t")
    table.sort(items, function(a, b)
        if a.name == current then
            return false
        elseif b.name == current then
            return true
        end
        return a.modify_time > b.modify_time
    end)
    local picker_items = vim.tbl_map(function(item)
        return { text = item.name, label = item.name .. " (" .. item.type .. ")" }
    end, items)
    Snacks.picker {
        title = "Select Session",
        items = picker_items,
        layout = { preset = "select" },
        confirm = function(picker, item)
            picker:close()
            if not item then
                return
            end
            if confirm_discard_changes() then
                MiniSessions.read(item.text, { force = true })
            end
        end,
    }
end, { desc = "Select session" })
vim.keymap.set("n", "<leader>sw", function()
    vim.ui.input({
        prompt = "Session Name: ",
        default = vim.v.this_session ~= "" and vim.v.this_session or vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
    }, function(input)
        if input ~= nil then
            MiniSessions.write(input, { force = true })
        end
    end)
end, { desc = "Save session" })
vim.keymap.set("n", "<leader>sx", function()
    if confirm_discard_changes() then
        vim.v.this_session = ""
        vim.cmd "%bwipeout!"
        vim.cmd "cd ~"
    end
end, { desc = "Clear current session" })

local MiniSplitjoin = require "mini.splitjoin"
MiniSplitjoin.setup {
    detect = {
        brackets = { "%b||", "%b()", "%b[]", "%b{}" },
        separator = "[,;]",
    },
    join = {
        hooks_post = { MiniSplitjoin.gen_hook.pad_brackets { brackets = { "%b||", "%b[]", "%b{}" } } },
    },
}

require("mini.statusline").setup {}

require("mini.surround").setup {
    mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
    },
    search_method = "cover_or_next",
}
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", ":<C-u>lua MiniSurround.add('visual')<CR>", { silent = true })
vim.keymap.set("n", "yss", "ys_", { remap = true })
-- }}}

-- blink.cmp {{{
require("blink.cmp").setup {
    keymap = {
        preset = "none",
        ["<c-d>"] = { "scroll_documentation_down", "fallback" },
        ["<c-e>"] = { "hide", "fallback" },
        ["<c-n>"] = { "select_next", "fallback_to_mappings" },
        ["<c-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<c-s>"] = {
            function(cmp)
                cmp.hide_signature()
                vim.lsp.buf.signature_help()
            end,
        },
        ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<c-u>"] = { "scroll_documentation_up", "fallback" },
        ["<c-y>"] = { "select_and_accept", "fallback" },
        ["<cr>"] = { "accept", "fallback" },
        ["<down>"] = { "select_next", "fallback" },
        ["<s-tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<up>"] = { "select_prev", "fallback" },
    },
    cmdline = {
        keymap = {
            ["<c-space>"] = { "show", "hide", "fallback" },
            ["<s-tab>"] = { "show_and_insert", "select_prev", "fallback" },
            ["<tab>"] = { "show_and_insert", "select_next", "fallback" },
        },
        completion = {
            menu = {
                auto_show = function()
                    return vim.fn.getcmdtype() == ":"
                end,
            },
            list = { selection = { preselect = false } },
        },
    },
    completion = {
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = false } },
        documentation = { auto_show = true },
        ghost_text = { enabled = true },
    },
    sources = {
        default = { "lsp", "easy-dotnet", "path", "snippets", "buffer" },
        providers = {
            buffer = {
                opts = {
                    get_bufnrs = function()
                        return vim.tbl_filter(function(bufnr)
                            local buftype = vim.bo[bufnr]
                            return buftype == "" or buftype == "help"
                        end, vim.api.nvim_list_bufs())
                    end,
                },
            },
            ["easy-dotnet"] = {
                name = "easy-dotnet",
                enabled = true,
                module = "easy-dotnet.completion.blink",
                score_offset = 10000,
                async = true,
            },
        },
    },
    signature = { enabled = true },
}
-- }}}

-- Miscellaneous plugins {{{
require("easy-dotnet").setup {}
vim.keymap.set("n", "<leader>o", "<cmd>Dotnet<cr>", { desc = "Open Dotnet UI" })

require("gruvbox").setup { italic = { strings = false }, contrast = "hard" }
vim.cmd.colorscheme "gruvbox"

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gl", "<cmd>Neogit log<cr>", { desc = "Git log" })
vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<cr>", { desc = "Git pull" })
vim.keymap.set("n", "<leader>gP", "<cmd>Neogit push<cr>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gz", "<cmd>Neogit stash<cr>", { desc = "Git stash" })

require("quicker").setup {}

require("ultimate-autopair").setup {
    { "[|", "|]", fly = true, dosuround = true, newline = true, space = true },
    { "(|", "|)", fly = true, dosuround = true, newline = true, space = true, disable_end = true },
    { "{|", "|}", fly = true, dosuround = true, newline = true, space = true },
    { "[<", ">]", fly = true, dosuround = true, newline = true, space = true },
    { ">", "<", newline = true, disable_start = true, disable_end = true },
    {
        "'",
        "'",
        suround = true,
        cond = function(fn)
            return not fn.in_lisp() or fn.in_string()
        end,
        alpha = true,
        nft = { "tex", "fsharp" },
        multiline = false,
    },
    {
        "`",
        "`",
        cond = function(fn)
            return not fn.in_lisp() or fn.in_string()
        end,
        nft = { "tex", "fsharp" },
        multiline = false,
    },
    { "```", "```", newline = true },
    { '"""', '"""', newline = true },
    { "'''", "'''", newline = true },
    bs = { cmap = "<m-bs>" },
    space2 = { enable = true },
    tabout = { enable = true, map = "<m-]>", cmap = "<m-]>", hopout = true },
}
-- }}}

-- LSP config {{{
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", { capabilities = capabilities })
vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
    settings = {
        Lua = {
            hint = {
                enable = true,
            },
            runtime = {
                version = "LuaJIT",
            },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        },
    },
})
vim.lsp.enable "lua_ls"
vim.lsp.config("fsautocomplete", {
    capabilities = capabilities,
    on_attach = function(client)
        client.server_capabilities.semanticTokensProvider = nil
    end,
    flags = { debounce_text_changes = 100 },
    settings = {
        FSharp = { ExternalAutocomplete = true },
    },
})
vim.lsp.enable "fsautocomplete"

require("mason").setup {
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
}
vim.keymap.set("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Open Mason UI" })
require("conform").setup { default_format_opts = { lsp_format = "fallback" }, format_on_save = { timeout_ms = 500 } }
require("mason-lspconfig").setup {}
require("mason-conform").setup {}
-- }}}

-- Deferred settings {{{
vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)
-- vim: set foldmethod=marker: }}}
