vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.conceallevel = 2
vim.o.confirm = true
vim.o.expandtab = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.guifont = "Iosevka NF,Iosevka Nerd Font,Iosevka:h15"
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.infercase = true
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = "a"
vim.o.mousemodel = "popup"
vim.o.number = true
vim.o.pumblend = 10
vim.o.pumheight = 10
vim.o.ruler = false
vim.o.shellslash = true
vim.o.shiftwidth = 4
vim.o.shortmess = "aoOtTcCFS"
vim.o.showmode = false
vim.o.signcolumn = "yes:1"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelllang = "en_ca,en"
vim.o.spelloptions = "camel,noplainbuffer"
vim.o.startofline = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.updatetime = 1000
vim.o.viewoptions = "folds,cursor"
vim.o.virtualedit = "block"
vim.o.whichwrap = "b,s,<,>,[,]"
vim.o.winblend = 10
vim.opt.listchars = { leadmultispace = "▏   ", tab = "> ", trail = "-", nbsp = "+" }

if os.getenv "SSH_CONNECTION" == nil then
    vim.o.title = true
end

if vim.g.neovide then
    vim.g.neovide_input_macos_alt_is_meta = true
    vim.keymap.set("n", "<leader>tf", function()
        vim.g.neovide_fullscreen = vim.g.neovide_fullscreen == 1 and 0 or 1
    end, { desc = "Toggle fullscreen" })
end
