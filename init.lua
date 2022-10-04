local g = vim.g
local fn = vim.fn
local opt = vim.opt

if vim.loop.os_uname().sysname == "Windows" then
    opt.shell = "pwsh"
    g.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    g.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    g.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    opt.shellquote = ""
    opt.shellxquote = ""
end

g.loaded = 1
g.loaded_netrwPlugin = 1
g.mapleader = " "
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.expandtab = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 2
opt.shiftwidth = 4
opt.signcolumn = "yes:1"

local ensure_packer = function()
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"
    use "sheerun/vim-polyglot"
    use "tpope/vim-repeat"
    use "tpope/vim-unimpaired"
    use "tpope/vim-speeddating"
    use "tpope/vim-surround"
    use {
        "gruvbox-community/gruvbox",
        config = function()
            vim.g.gruvbox_italic = 1
            vim.g.gruvbox_sign_column = "none"
            vim.cmd [[colorscheme gruvbox]]
            vim.cmd [[highlight MatchWord ctermbg=black guibg=black]]
        end,
    }
    use(require "plugin/whichkey")
    use(require "plugin/lsp")
    use(require "plugin/treesitter")
    use(require "plugin/gitsigns")
    use(require "plugin/telescope")
    use(require "plugin/nvimtree")
    use(require "plugin/neogit")
    use {
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup {
                open_mapping = "<c-\\>",
            }
        end,
    }

    if packer_bootstrap then
        require("packer").sync()
    end
end)
