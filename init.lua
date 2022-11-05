require "settings" -- General settings
require "autocommands" -- Autocommands
require "powershell" -- Use PowerShell on Windows

-- Packer bootstrap
local ensure_packer = function()
    local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
        vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
        vim.cmd.packadd "packer.nvim"
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    -- Basic plugin imports
    use "adelarsq/neofsharp.vim"
    use "digitaltoad/vim-pug"
    use "michaeljsmith/vim-indent-object"
    use "svermeulen/vim-extended-ft"
    use "tpope/vim-fugitive"
    use "tpope/vim-repeat"
    use "tpope/vim-rhubarb"
    use "tpope/vim-rsi"
    use "tpope/vim-sleuth"
    use "tpope/vim-speeddating"
    use "tpope/vim-surround"
    use "tpope/vim-unimpaired"
    use "vim-scripts/ReplaceWithRegister"
    use "wellle/targets.vim"

    -- Plugins with configurations
    use(require "plugin/align")
    use(require "plugin/bufdel")
    use(require "plugin/cmp")
    use(require "plugin/colors")
    use(require "plugin/comment")
    use(require "plugin/csv")
    use(require "plugin/fold")
    use(require "plugin/gitsigns")
    use(require "plugin/gruvbox")
    use(require "plugin/indent")
    use(require "plugin/lsp")
    use(require "plugin/neogit")
    use(require "plugin/nvimtree")
    use(require "plugin/orgmode")
    use(require "plugin/session")
    use(require "plugin/signature")
    use(require "plugin/telescope")
    use(require "plugin/toggleterm")
    use(require "plugin/treesitter")
    use(require "plugin/vimqf")
    use(require "plugin/whichkey")

    if packer_bootstrap then
        require("packer").sync()
    end
end)
