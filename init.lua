require "settings" -- General settings
require "autocommands" -- Autocommands
require "powershell" -- Use PowerShell on Windows

-- Packer bootstrap {{{
local ensure_packer = function()
    local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
        vim.cmd "packadd packer.nvim"
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
-- }}}

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use "michaeljsmith/vim-indent-object"
    use "sheerun/vim-polyglot"
    use "svermeulen/vim-extended-ft"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-rhubarb"
    use "tpope/vim-rsi"
    use "tpope/vim-speeddating"
    use "tpope/vim-surround"
    use "vim-scripts/ReplaceWithRegister"
    use "wellle/targets.vim"

    use(require "plugin/gitsigns")
    use(require "plugin/gruvbox")
    use(require "plugin/indent")
    use(require "plugin/lsp")
    use(require "plugin/neogit")
    use(require "plugin/nvimtree")
    use(require "plugin/orgmode")
    use(require "plugin/session")
    use(require "plugin/telescope")
    use(require "plugin/treesitter")
    use(require "plugin/trouble")
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
    use { -- brenoprata10/nvim-highlight-colors {{{
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup {
                enable_tailwind = true,
            }
        end,
    } -- }}}
    use { -- junegunn/vim-easy-align {{{
        "junegunn/vim-easy-align",
        requires = "folke/which-key.nvim",
        config = function()
            local wk = require "which-key"
            wk.register { gl = { "<plug>(EasyAlign)", "Align items" } }
            wk.register({ gl = { "<plug>(EasyAlign)", "Align items" } }, { mode = "x" })
        end,
    } -- }}}
    use { -- mechatroner/rainbow_csv {{{
        "mechatroner/rainbow_csv",
        config = function()
            vim.g.rbql_backend_language = "js"
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
