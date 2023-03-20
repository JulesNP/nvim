require "settings" -- General settings
require "autocommands" -- Autocommands
require "powershell" -- Use PowerShell on Windows

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
    -- Basic plugin imports
    "tpope/vim-repeat",
    "tpope/vim-speeddating",
    "tpope/vim-surround",
    "tpope/vim-unimpaired",
    "wellle/targets.vim",

    -- Plugins with configurations
    (require "plugin/align"),
    (require "plugin/comment"),
    (require "plugin/eyeliner"),
    (require "plugin/indent-tools"),
    (require "plugin/leap"),
    (require "plugin/substitute"),
    (require "plugin/textobjects"),
    (require "plugin/treesitter"),
    (require "plugin/whichkey"),
    (require "plugin/wordmotion"),

    -- if not vim.g.vscode then
    "tpope/vim-rsi",

    (require "plugin/alpha"),
    (require "plugin/autopairs"),
    (require "plugin/autotag"),
    (require "plugin/bufdel"),
    (require "plugin/cmp"),
    (require "plugin/colors"),
    (require "plugin/csv"),
    (require "plugin/diffview"),
    (require "plugin/git"),
    (require "plugin/gitsigns"),
    (require "plugin/gruvbox"),
    (require "plugin/guess-indent"),
    (require "plugin/illuminate"),
    (require "plugin/inlay-hints"),
    (require "plugin/lsp"),
    (require "plugin/lualine"),
    (require "plugin/maximize"),
    (require "plugin/neotree"),
    (require "plugin/orgmode"),
    (require "plugin/quickfix"),
    (require "plugin/refactor"),
    (require "plugin/session"),
    (require "plugin/tabout"),
    (require "plugin/telescope"),
    (require "plugin/toggleterm"),
    (require "plugin/ufo"),
    -- end
}
