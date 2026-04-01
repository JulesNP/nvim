vim.pack.add {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range "1.x" },
    "https://github.com/neogitorg/neogit",
    "https://github.com/folke/snacks.nvim",
}

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "fuzzy,menuone,noinsert,noselect"
vim.o.conceallevel = 2
vim.o.confirm = true
vim.opt.diffopt:append { algorithm = "histogram" }
vim.o.expandtab = true
vim.o.foldlevel = 99
vim.o.foldtext = ""
vim.o.inccommand = "split"
vim.o.shiftwidth = 4
-- vim.o.shiftround = true
-- vim.o.shortmess = "filmnrxoOtTcCFS"
-- vim.o.signcolumn = "number"
vim.o.spelllang = "en_ca,en"
vim.o.spelloptions = "camel,noplainbuffer"
vim.o.startofline = true
vim.o.whichwrap = "b,s,<,>,[,]"
if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.o.shellslash = true
    vim.cmd [[
        set noshelltemp
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

vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { desc = "Signature help" })

require("mini.basics").setup {
    options = {
        extra_ui = true,
        win_borders = "single",
    },
}

require("mini.icons").setup {}

local Snacks = require "snacks"
Snacks.setup {
    bigfile = { enabled = true },
    terminal = { enabled = true },
    picker = { enabled = true },
}
vim.keymap.set({ "n", "t" }, "<c-\\>", Snacks.terminal.toggle, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader><leader>", Snacks.picker.recent, { desc = "Find recent file" })
vim.keymap.set("n", "<leader>f<leader>", Snacks.picker.resume, { desc = "Resume last find" })
vim.keymap.set("n", "<leader>ff", Snacks.picker.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep, { desc = "Find with grep" })
vim.keymap.set("n", "<leader>fh", Snacks.picker.help, { desc = "Find help" })
vim.keymap.set({ "n", "x" }, "<leader>fw", Snacks.picker.grep_word, { desc = "Find <word>" })

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if
            ev.match == "c"
            or ev.match == "lua"
            or ev.match == "markdown"
            or ev.match == "vim"
            or ev.match == "vimdoc"
            or ev.match == "query"
            or vim.tbl_contains(require("nvim-treesitter").get_installed(), ev.match)
        then
            vim.treesitter.start()
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldmethod = "expr"
        end
    end,
})

local gen_ai_spec = require("mini.extra").gen_ai_spec
require("mini.ai").setup {
    custom_textobjects = {
        B = gen_ai_spec.buffer(),
        D = gen_ai_spec.diagnostic(),
        I = gen_ai_spec.indent(),
        L = gen_ai_spec.line(),
        N = gen_ai_spec.number(),
    },
}

require("mini.align").setup {}

require("mini.surround").setup {}

local MiniClue = require "mini.clue"
MiniClue.setup {
    triggers = {
        { mode = { "n", "x" }, keys = "<leader>" },
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

-- require("mini.cmdline").setup {}

local MiniFiles = require "mini.files"
MiniFiles.setup {}
vim.keymap.set("n", "-", MiniFiles.open, { desc = "Open Mini Files" })
vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionRename",
    callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
})

local cmp = require "blink.cmp"
cmp.setup {
    keymap = { preset = "enter" },
    completion = { documentation = { auto_show = true } },
    signature = { enabled = true },
    sources = {
        providers = {
            buffer = {
                opts = {
                    get_bufnrs = vim.api.nvim_list_bufs,
                },
            },
        },
    },
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

require("conform").setup {
    formatters_by_ft = {
        fsharp = { "fantomas" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
}

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
