vim.g.mapleader = " "
vim.g.maplocalleader = " "
local o = vim.o
o.backup = false
o.clipboard = "unnamedplus"
o.completeopt = "menuone,noinsert,noselect"
o.conceallevel = 2
o.confirm = true
o.expandtab = true
o.foldlevel = 99
o.foldlevelstart = 99
o.guifont = "Iosevka Nerd Font"
o.ignorecase = true
o.inccommand = "split"
o.infercase = true
o.linebreak = true
o.mouse = "a"
o.mousemodel = "popup"
o.number = true
o.pumblend = 10
o.pumheight = 10
o.ruler = false
-- o.shellslash = true
o.shiftwidth = 4
o.shortmess = "filmnrxoOtTcCFS"
o.showmode = false
o.signcolumn = "yes:1"
o.smartcase = true
o.smartindent = true
o.spelllang = "en_ca,en"
o.spelloptions = "camel,noplainbuffer"
o.startofline = true
o.termguicolors = true
o.undofile = true
o.updatetime = 1000
o.viewoptions = "folds,cursor"
o.virtualedit = "block"
o.whichwrap = "b,s,<,>,[,]"
o.winblend = 10
o.wrap = false
o.writebackup = false

vim.diagnostic.config { virtual_text = { prefix = " " } }

if os.getenv "SSH_CONNECTION" == nil then
    o.title = true
end

if vim.g.neovide then
    vim.g.neovide_input_macos_alt_is_meta = true
    vim.keymap.set("n", "<leader>tf", function()
        vim.g.neovide_fullscreen = vim.g.neovide_fullscreen == 1 and 0 or 1
    end, { desc = "Toggle fullscreen" })
end
