vim.g.mapleader = " "
vim.g.maplocalleader = " "
if vim.g.neovide then
    vim.g.neovide_floating_blur_amount_x = 6.0
    vim.g.neovide_floating_blur_amount_y = 6.0
    vim.o.pumblend = 30
    vim.o.winblend = 30
else
    vim.o.clipboard = "unnamedplus"
end
vim.o.completeopt = "menu,menuone,noselect"
vim.o.concealcursor = "nc"
vim.o.conceallevel = 2
vim.o.confirm = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.foldcolumn = "auto"
vim.o.guifont = "Iosevka,Iosevka NF:h15"
vim.o.ignorecase = true
vim.o.linebreak = true
vim.o.nrformats = "alpha,bin,hex"
vim.o.number = true
vim.o.scrolloff = 5
vim.o.shiftwidth = 4
vim.o.showbreak = "↳ "
vim.o.showmode = false
vim.o.signcolumn = "yes:1"
vim.o.smartcase = true
vim.o.spelllang = "en_ca,en"
vim.o.startofline = true
vim.o.termguicolors = true
vim.o.title = true
vim.o.undofile = true
vim.o.viewoptions = "folds,cursor"
vim.o.whichwrap = "b,s,<,>,[,]"
