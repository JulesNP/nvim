if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.cmd [[
        let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
        let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
        let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
        let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        set shellquote= shellxquote=
    ]]
end

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.expandtab = true
vim.o.foldcolumn = "auto"
vim.o.ignorecase = true
vim.o.linebreak = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 2
vim.o.shiftwidth = 4
vim.o.showbreak = "↳ "
vim.o.signcolumn = "yes:1"
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.undofile = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "NeogitCommitMessage", "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.spell = true
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { timeout = 300 }
    end,
})

local ensure_packer = function()
    local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"
    use "sheerun/vim-polyglot"
    use "tpope/vim-fugitive"
    use "tpope/vim-rhubarb"
    use "tpope/vim-repeat"
    use "tpope/vim-rsi"
    use "tpope/vim-speeddating"
    use "tpope/vim-surround"
    use "vim-scripts/ReplaceWithRegister"
    use "wellle/targets.vim"
    use {
        "junegunn/vim-easy-align",
        config = function()
            require("which-key").register {
                gl = { "<plug>(EasyAlign)", "Align items", mode = "x" },
                g = {
                    l = { "<plug>(EasyAlign)", "Align items" },
                },
            }
        end,
    }
    use {
        "gruvbox-community/gruvbox",
        config = function()
            vim.g.gruvbox_italic = 1
            vim.g.gruvbox_sign_column = "none"
            vim.cmd [[colorscheme gruvbox]]
            vim.cmd [[highlight FoldColumn ctermbg=235 guibg=#282828]]
            vim.cmd [[highlight MatchParen ctermbg=237 guibg=#3c3836]]
        end,
    }
    use(require "plugin/whichkey")
    use(require "plugin/lsp")
    use(require "plugin/treesitter")
    use(require "plugin/gitsigns")
    use(require "plugin/telescope")
    use(require "plugin/nvimtree")
    use(require "plugin/neogit")
    use(require "plugin/session")
    use {
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup {
                open_mapping = "<c-\\>",
            }
        end,
    }
    use {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup {
                toggler = {
                    block = "g//",
                },
                opleader = {
                    block = "g/",
                },
            }
        end,
    }
    use {
        "mechatroner/rainbow_csv",
        config = function()
            vim.g.rbql_backend_language = "js"
        end,
    }
    use {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    }
    use {
        "anuvyklack/pretty-fold.nvim",
        config = function()
            require("pretty-fold").setup {}
        end,
    }
    use {
        "lukas-reineke/indent-blankline.nvim",
        after = "gruvbox",
        config = function()
            vim.g.indent_blankline_show_foldtext = false
            vim.cmd [[highlight IndentBlanklineIndent1 ctermbg=235 guibg=#282828]]
            vim.cmd [[highlight IndentBlanklineIndent2 ctermbg=236 guibg=#262626]]
            require("indent_blankline").setup {
                char = "",
                char_highlight_list = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                },
                space_char_highlight_list = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                },
                show_trailing_blankline_indent = false,
            }
        end,
    }

    if packer_bootstrap then
        require("packer").sync()
    end
end)
