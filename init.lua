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
    use "tpope/vim-repeat"
    use "tpope/vim-rsi"
    use "tpope/vim-sleuth"
    use "tpope/vim-speeddating"
    use "tpope/vim-surround"
    use "tpope/vim-unimpaired"
    use "vim-scripts/ReplaceWithRegister"
    use "wellle/targets.vim"

    -- Plugins with configurations
    use(require "plugin/align")
    use(require "plugin/alpha")
    use(require "plugin/bufdel")
    use(require "plugin/cmp")
    use(require "plugin/colors")
    use(require "plugin/comment")
    use(require "plugin/csv")
    use(require "plugin/diffview")
    use(require "plugin/eyeliner")
    use(require "plugin/fold")
    use(require "plugin/git")
    use(require "plugin/gitsigns")
    use(require "plugin/gruvbox")
    use(require "plugin/hop")
    use(require "plugin/indent-blankline")
    use(require "plugin/indent-tools")
    use(require "plugin/lsp")
    use(require "plugin/lualine")
    use(require "plugin/maximize")
    use(require "plugin/neotree")
    use(require "plugin/orgmode")
    use(require "plugin/session")
    use(require "plugin/signature")
    use(require "plugin/telescope")
    use(require "plugin/toggleterm")
    use(require "plugin/treesitter")
    use(require "plugin/vimqf")
    use(require "plugin/whichkey")

    -- Linux-specific plugin
    if vim.loop.os_uname().sysname == "Linux" then
        use(require "plugin/sniprun")
    end

    if packer_bootstrap then
        require("packer").sync()
    end
end)
