local fn = vim.fn
local opt = vim.opt

if vim.loop.os_uname().sysname == "Windows" then
    opt.shell = "pwsh"
    vim.g.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
    vim.g.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    vim.g.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
    opt.shellquote = ""
    opt.shellxquote = ""
end

opt.expandtab = true
opt.shiftwidth = 4
opt.signcolumn = "number"
opt.number = true
opt.relativenumber = true

vim.g.mapleader = " "

vim.cmd [[colorscheme gruvbox]]

local ensure_packer = function()
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
vim.cmd [[packadd packer.nvim]]
return true
end
return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
use 'wbthomason/packer.nvim'
use (require "lsp")
use 'gruvbox-community/gruvbox'
use {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup {}
  end
}
use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

if packer_bootstrap then
require('packer').sync()
end
end)
