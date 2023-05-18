require "settings" -- General settings
require "autocommands" -- Autocommands
require "powershell" -- Use PowerShell on Windows
require "keymaps" -- Load keymaps

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

require("lazy").setup(
    "plugins",
    { diff = { cmd = "diffview.nvim" }, change_detection = {
        enabled = true,
        notify = false,
    } }
)
