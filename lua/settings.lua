vim.g.show_inlay_hints = false
vim.g.show_mini_map = false
vim.g.mapleader = " "
vim.g.maplocalleader = " "
local o = vim.o
o.clipboard = "unnamedplus"
o.completeopt = "menuone,noinsert,noselect"
o.conceallevel = 2
o.confirm = true
vim.opt.diffopt = {
    "algorithm:histogram",
    "closeoff",
    "filler",
    "indent-heuristic",
    "internal",
    "linematch:60",
}
o.expandtab = true
vim.opt.fillchars:append({fold = " "})
o.foldcolumn = "0"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel = 99
o.foldmethod = "expr"
o.foldtext = ""
o.ignorecase = true
o.inccommand = "split"
o.infercase = true
o.linebreak = true
o.mouse = "a"
o.mousemodel = "popup"
o.number = true
o.pumheight = 10
o.ruler = false
o.shiftwidth = 4
o.shiftround = true
o.shortmess = "filmnrxoOtTcCFS"
o.showmode = false
o.signcolumn = "number"
o.smartcase = true
o.smartindent = true
o.spelllang = "en_ca,en"
o.spelloptions = "camel,noplainbuffer"
o.startofline = true
o.termguicolors = true
o.undofile = true
o.updatetime = 1000
o.viewoptions = "folds,cursor"
o.whichwrap = "b,s,<,>,[,]"
o.winborder = "rounded"
o.wrap = false

if os.getenv "SSH_CONNECTION" == nil then
    o.title = true
end

if vim.g.neovide then
    o.inccommand = "nosplit"
    o.pumblend = 10
    o.winblend = 10
    vim.g.neovide_input_macos_option_key_is_meta = "both"
    vim.keymap.set("n", "<leader>tf", function()
        vim.g.neovide_fullscreen = vim.g.neovide_fullscreen == 1 and 0 or 1
    end, { desc = "Toggle fullscreen" })
end
