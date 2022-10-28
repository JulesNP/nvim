return {
    "gruvbox-community/gruvbox",
    config = function()
        vim.g.gruvbox_invert_selection = 0
        vim.g.gruvbox_italic = 1
        vim.g.gruvbox_sign_column = "none"

        vim.cmd "colorscheme gruvbox"
        vim.cmd "highlight CursorLine ctermbg=236 guibg=#32302f"
        vim.cmd "highlight CursorLineNr ctermbg=235 guibg=#282828"
        vim.cmd "highlight FoldColumn ctermbg=235 guibg=#282828"
        vim.cmd "highlight IndentBlanklineChar cterm=nocombine ctermfg=234 gui=nocombine guifg=#1d2021"
        vim.cmd "highlight MatchParen ctermbg=237 guibg=#3c3836"

        local augroup_id = vim.api.nvim_create_augroup("CursorLineInsertToggle", { clear = true })
        vim.api.nvim_create_autocmd("InsertEnter", {
            group = augroup_id,
            pattern = "*",
            callback = function()
                vim.cmd "highlight CursorLine ctermbg=none guibg=none"
            end,
        })
        vim.api.nvim_create_autocmd("InsertLeave", {
            group = augroup_id,
            pattern = "*",
            callback = function()
                vim.cmd "highlight CursorLine ctermbg=236 guibg=#32302f"
            end,
        })
    end,
}
