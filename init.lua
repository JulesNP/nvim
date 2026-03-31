vim.pack.add {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/neogitorg/neogit",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/neovim/nvim-lspconfig"
}

if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.o.shellslash = true
    vim.cmd [[
        set noshelltemp
        let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
        let &shellcmdflag .= '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
        let &shellcmdflag .= '$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';'
        let &shellpipe  = '> %s 2>&1'
        set shellquote= shellxquote=
        let &shellcmdflag .= '$PSStyle.OutputRendering = ''PlainText'';'
        " Workaround (may not be needed in future version of pwsh):
        let $__SuppressAnsiEscapeSequences = 1
    ]]
end

vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })

require("mini.basics").setup{
    options = {
        extra_ui = true
    }
}

require("mini.files").setup{}
vim.keymap.set("n", "-", MiniFiles.open, { desc = "Open Mini Files" })

vim.lsp.enable "lua_ls"
