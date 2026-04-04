vim.pack.add {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/zapling/mason-conform.nvim",
    "https://github.com/seblyng/roslyn.nvim",
    "https://github.com/tpope/vim-rsi",
    "https://github.com/nvim-mini/mini.nvim",
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range "1.x" },
    "https://github.com/neogitorg/neogit",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/mechatroner/rainbow_csv",
}

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.clipboard = "unnamedplus"
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
if vim.loop.os_uname().sysname == "Windows_NT" then
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

vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>", { desc = ":help CTRL-L-default" })
vim.keymap.set("n", "<c-s>", function()
    require("conform").format()
    vim.cmd "mkview"
    vim.cmd "update"
end, { desc = "Format & save" })
vim.keymap.set("n", "<m-s>", "<cmd>mkview<bar>wall<cr>", { desc = "Save all buffers" })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("t", "<c-h>", "<c-\\><c-n><c-w><c-h>")
vim.keymap.set("t", "<c-j>", "<c-\\><c-n><c-w><c-j>")
vim.keymap.set("t", "<c-k>", "<c-\\><c-n><c-w><c-k>")
vim.keymap.set("t", "<c-l>", "<c-\\><c-n><c-w><c-l>")

require("mini.basics").setup {
    mappings = { basic = false, windows = true },
    autocommands = { relnum_in_visual_mode = true },
}
require("mini.icons").setup {}

local Snacks = require "snacks"
Snacks.setup {
    bigfile = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    terminal = { enabled = true },
}
vim.keymap.set({ "n", "t" }, "<c-\\>", Snacks.terminal.toggle, { desc = "Toggle terminal" })
vim.keymap.set("n", "go", Snacks.picker.lsp_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "gO", Snacks.picker.lsp_workspace_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader><leader>", Snacks.picker.smart, { desc = "Find recent file" })
vim.keymap.set("n", "<leader>f<leader>", Snacks.picker.resume, { desc = "Resume last find" })
vim.keymap.set("n", "<leader>fc", Snacks.picker.colorschemes, { desc = "Find colorscheme" })
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics, { desc = "Find diagnostic" })
vim.keymap.set("n", "<leader>ff", Snacks.picker.files, { desc = "Find file" })
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers, { desc = "Find buffer" })
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep, { desc = "Find with grep" })
vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "Find help" })
vim.keymap.set("n", "<leader>fH", Snacks.picker.highlights, { desc = "Find highlight" })
vim.keymap.set("n", "<leader>fk", Snacks.picker.keymaps, { desc = "Find keymap" })
vim.keymap.set("n", "<leader>fp", Snacks.picker.projects, { desc = "Find project" })
vim.keymap.set({ "n", "x" }, "<leader>fw", Snacks.picker.grep_word, { desc = "Find <word>" })
vim.api.nvim_create_autocmd("FileType", {
    callback = function(event)
        if
            event.match == "c"
            or event.match == "lua"
            or event.match == "markdown"
            or event.match == "vim"
            or event.match == "vimdoc"
            or event.match == "query"
            or vim.tbl_contains(require("nvim-treesitter").get_installed(), event.match)
        then
            vim.treesitter.start()
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldmethod = "expr"
        end
    end,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*.*",
    callback = function()
        vim.cmd "silent! mkview"
    end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.*",
    callback = function()
        vim.cmd "silent! loadview"
    end,
})

local gen_extra = require("mini.extra").gen_ai_spec
require("mini.ai").setup {
    custom_textobjects = {
        a = require("mini.ai").gen_spec.argument { separator = "[,;]" },
        N = gen_extra.number(),
        d = gen_extra.diagnostic(),
        g = gen_extra.buffer(),
    },
}
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

require("mini.indentscope").setup {
    draw = { animation = require("mini.indentscope").gen_animation.none() },
    options = { indent_at_cursor = false },
    symbol = "▏",
}
Snacks.util.set_hl { MiniIndentscopeSymbol = { link = "NonText" } }

require("mini.diff").setup {}
vim.keymap.set("n", "\\o", require("mini.diff").toggle_overlay, { desc = "Tooggle diff overlay" })

require("mini.align").setup {}
require("mini.move").setup { options = { reindent_linewise = false } }
require("mini.sessions").setup {}
require("mini.splitjoin").setup {}
require("mini.surround").setup {}

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
    },
}

local MiniFiles = require "mini.files"
MiniFiles.setup {
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
        vim.keymap.set("n", "<esc>", MiniFiles.close, { buffer = buf_id, desc = "Close" })
        vim.keymap.set("n", "-", MiniFiles.go_out, { buffer = buf_id, desc = "Go out of directory" })
        vim.keymap.set("n", "gh", "h", { buffer = buf_id, desc = "Left" })
        vim.keymap.set("n", "gl", "l", { buffer = buf_id, desc = "Right" })
        vim.keymap.set("n", "<c-\\>", function()
            local fs_entry = MiniFiles.get_fs_entry()
            Snacks.terminal.open(nil, { cwd = vim.fs.dirname(fs_entry.path) })
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
            local cwd = vim.fs.dirname(MiniFiles.get_fs_entry().path)
            vim.fn.chdir(cwd)
            vim.notify("CWD set to: " .. cwd)
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

require("mason").setup {
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
}

local cmp = require "blink.cmp"
cmp.setup {
    keymap = {
        preset = "none",
        ["<c-d>"] = { "scroll_documentation_down", "fallback" },
        ["<c-e>"] = { "hide", "fallback" },
        ["<c-n>"] = { "select_next", "fallback_to_mappings" },
        ["<c-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<c-s>"] = {
            function(_cmp)
                _cmp.hide_signature()
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
    sources = { providers = { buffer = { opts = { get_bufnrs = vim.api.nvim_list_bufs } } } },
    signature = { enabled = true },
}
local capabilities = cmp.get_lsp_capabilities()

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
    flags = { debounce_text_changes = 150 },
    settings = {
        FSharp = { ExternalAutocomplete = true },
    },
})
vim.lsp.enable "fsautocomplete"

local orig_hover = vim.lsp.handlers["textDocument/hover"]

require("conform").setup { default_format_opts = { lsp_format = "fallback" } }
require("mason-lspconfig").setup {}
require("mason-conform").setup {}

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<cr>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gl", "<cmd>Neogit log<cr>", { desc = "Git log" })
vim.keymap.set("n", "<leader>gp", "<cmd>Neogit pull<cr>", { desc = "Git pull" })
