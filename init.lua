-- General settings {{{
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.conceallevel = 2
vim.o.expandtab = true
vim.o.foldcolumn = "auto"
vim.o.ignorecase = true
vim.o.linebreak = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 5
vim.o.shiftwidth = 4
vim.o.showbreak = "↳ "
vim.o.signcolumn = "yes:1"
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.undofile = true
-- }}}

-- Use PowerShell on Windows {{{
if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.cmd [[
        let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
        let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
        let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
        let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
        set shellquote= shellxquote=
    ]]
end
-- }}}

-- Autocommands {{{
vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.*",
    callback = function()
        vim.cmd [[silent! loadview]]
    end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*.*",
    callback = function()
        vim.cmd [[mkview]]
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "NeogitCommitMessage", "gitcommit", "markdown", "text" },
    callback = function()
        vim.cmd [[setlocal spell]]
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.opt_local.suffixesadd:prepend ".lua"
        vim.opt_local.suffixesadd:prepend "init.lua"
        vim.opt_local.path:prepend(vim.fn.stdpath "config" .. "/lua")
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank { timeout = 300 }
    end,
})
-- }}}

-- Packer bootstrap {{{
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
-- }}}

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use "sheerun/vim-polyglot"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-rhubarb"
    use "tpope/vim-rsi"
    use "tpope/vim-speeddating"
    use "tpope/vim-surround"
    use "vim-scripts/ReplaceWithRegister"
    use "wellle/targets.vim"

    use(require "plugin/gitsigns")
    use(require "plugin/indent")
    use(require "plugin/lsp")
    use(require "plugin/neogit")
    use(require "plugin/nvimtree")
    use(require "plugin/session")
    use(require "plugin/telescope")
    use(require "plugin/treesitter")
    use(require "plugin/whichkey")

    use { -- akinsho/toggleterm.nvim {{{
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup {
                open_mapping = "<c-\\>",
            }
        end,
    } -- }}}
    use { -- anuvyklack/pretty-fold.nvim {{{
        "anuvyklack/pretty-fold.nvim",
        config = function()
            require("pretty-fold").setup {
                fill_char = " ",
                process_comment_signs = "delete",
                sections = {
                    left = { "content" },
                    right = { " ", "number_of_folded_lines", ": ", "percentage", " " },
                },
            }
        end,
    } -- }}}
    use { -- folke/trouble.nvim {{{
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            local trouble = require "trouble"
            trouble.setup {
                auto_jump = { "lsp_definitions", "lsp_implementations", "lsp_type_definitions" },
                signs = {
                    hint = "",
                    information = "",
                    warning = "",
                    error = "",
                    other = "",
                },
            }
        end,
    } -- }}}
    use { -- gruvbox-community/gruvbox {{{
        "gruvbox-community/gruvbox",
        config = function()
            vim.g.gruvbox_italic = 1
            vim.g.gruvbox_sign_column = "none"
            vim.cmd [[colorscheme gruvbox]]
            vim.cmd [[highlight FoldColumn ctermbg=235 guibg=#282828]]
            vim.cmd [[highlight MatchParen ctermbg=237 guibg=#3c3836]]
        end,
    } -- }}}
    use { -- junegunn/vim-easy-align {{{
        "junegunn/vim-easy-align",
        config = function()
            require("which-key").register {
                gl = { "<plug>(EasyAlign)", "Align items", mode = "x" },
                g = {
                    l = { "<plug>(EasyAlign)", "Align items" },
                },
            }
        end,
    } -- }}}
    use { -- mechatroner/rainbow_csv {{{
        "mechatroner/rainbow_csv",
        config = function()
            vim.g.rbql_backend_language = "js"
        end,
    } -- }}}
    use { -- norcalli/nvim-colorizer.lua {{{
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    } -- }}}
    use { -- numToStr/Comment.nvim {{{
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
    } -- }}}
    use { -- ojroques/nvim-bufdel {{{
        "ojroques/nvim-bufdel",
        config = function()
            require("bufdel").setup {
                next = "alternate",
                quit = false,
            }
        end,
    } -- }}}

    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- vim: fdm=marker
