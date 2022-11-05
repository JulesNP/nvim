return {
    "gruvbox-community/gruvbox",
    requires = "folke/which-key.nvim",
    config = function()
        local function setup()
            vim.cmd.colorscheme "gruvbox"
            if vim.o.background == "dark" then
                vim.cmd.highlight "Cursor ctermbg=230 ctermfg=234 guibg=#f9f5d7 guifg=#1d2021"
                vim.cmd.highlight "CursorLine ctermbg=236 guibg=#32302f"
                vim.cmd.highlight "CursorLineNr ctermbg=235 guibg=#282828"
                vim.cmd.highlight "FoldColumn ctermbg=235 guibg=#282828"
                vim.cmd.highlight "IndentBlanklineChar cterm=nocombine ctermfg=234 gui=nocombine guifg=#1d2021"
                vim.cmd.highlight "MatchParen ctermbg=237 guibg=#3c3836"
            else
                vim.cmd.highlight "Cursor cterm=nocombine ctermbg=234 ctermfg=230 gui=nocombine guibg=#1d2021 guifg=#f9f5d7"
                vim.cmd.highlight "CursorLine ctermbg=230 guibg=#f9f5d7"
                vim.cmd.highlight "CursorLineNr ctermbg=229 guibg=#fbf1c7"
                vim.cmd.highlight "FoldColumn ctermbg=229 guibg=#fbf1c7"
                vim.cmd.highlight "IndentBlanklineChar cterm=nocombine ctermfg=228 gui=nocombine guifg=#f2e5bc"
                vim.cmd.highlight "MatchParen ctermbg=223 guibg=#ebdbb2"
            end
        end

        vim.g.gruvbox_invert_selection = 0
        vim.g.gruvbox_italic = 1
        vim.g.gruvbox_sign_column = "none"
        setup()

        require("which-key").register {
            ["<leader>tt"] = {
                function()
                    if vim.o.background == "dark" then
                        vim.o.background = "light"
                    else
                        vim.o.background = "dark"
                    end
                    setup()
                end,
                "Toggle theme",
            },
        }
    end,
}
