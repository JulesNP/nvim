local fn = vim.fn
local opt = vim.opt

if vim.loop.os_uname().sysname == "Windows" then
    opt.shell = "pwsh"
    vim.g.shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    vim.g.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.g.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    opt.shellquote = ""
    opt.shellxquote = ""
end

opt.expandtab = true
opt.shiftwidth = 4
opt.signcolumn = "yes:1"
opt.number = true
opt.relativenumber = true
vim.g.mapleader = " "
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

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
    use {
        "gruvbox-community/gruvbox",
        config = function()
            vim.g.gruvbox_italic = 1
            vim.g.gruvbox_sign_column = "none"
            vim.cmd [[colorscheme gruvbox]]
        end,
    }
    use {
        "folke/which-key.nvim",
        config = function()
            local wk = require "which-key"
            wk.setup()
            wk.register {
                ["<leader>ps"] = { "<cmd>PackerSync<cr>", "PackerSync" },
            }
        end,
    }
    use(require "plugin/lsp")
    use(require "plugin/gitsigns")
    use {
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons",
        },
        tag = "nightly",
        config = function()
            require("nvim-tree").setup {
                filters = {
                    custom = { "^.git$" },
                },
            }
            require("which-key").register {
                ["<c-n>"] = { "<cmd>NvimTreeToggle<cr>", "Toggle NvimTree" },
            }
        end,
    }
    use {
        "TimUntersberger/neogit",
        requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
        config = function()
            local neogit = require "neogit"
            neogit.setup {
                disable_commit_confirmation = true,
                disable_insert_on_commit = false,
                integrations = {
                    diffview = true,
                },
            }
            require("which-key").register {
                ["<leader>gg"] = {
                    function()
                        neogit.open { cwd = (vim.fn.expand "%:p:h") }
                    end,
                    "Neogit",
                },
                ["<leader>c"] = {
                    function()
                        neogit.open { "commit", cwd = (vim.fn.expand "%:p:h") }
                    end,
                    "create commit",
                },
            }
        end,
    }

    if packer_bootstrap then
        require("packer").sync()
    end
end)
