return {
    "gruvbox-community/gruvbox",
    requires = "folke/which-key.nvim",
    config = function()
        local function setup()
            vim.cmd.colorscheme "gruvbox"
            if vim.o.background == "dark" then
                vim.cmd.highlight "Cursor cterm=NONE ctermfg=234 ctermbg=230 gui=NONE guifg=#1d2021 guibg=#f9f5d7"
                vim.cmd.highlight "CursorLine ctermbg=236 guibg=#32302f"
                vim.cmd.highlight "CursorLineNr ctermbg=235 guibg=#282828"
                vim.cmd.highlight "FoldColumn ctermbg=235 guibg=#282828"
                vim.cmd.highlight "IndentBlanklineChar cterm=nocombine ctermfg=234 gui=nocombine guifg=#1d2021"
                vim.cmd.highlight "MatchParen ctermbg=237 guibg=#3c3836"
                vim.cmd.highlight "TelescopePromptBorder ctermbg=236 guibg=#32302f"
                vim.cmd.highlight "TelescopePromptNormal ctermbg=236 guibg=#32302f"
                vim.cmd.highlight "TelescopePromptTitle ctermbg=236 guibg=#32302f"
                vim.cmd.highlight "TelescopeResultsBorder ctermbg=237 guibg=#3c3836"
                vim.cmd.highlight "TelescopeResultsNormal ctermbg=237 guibg=#3c3836"
                vim.cmd.highlight "TelescopeResultsTitle ctermbg=237 guibg=#3c3836"
                vim.cmd.highlight "TelescopePreviewBorder ctermbg=239 guibg=#504945"
                vim.cmd.highlight "TelescopePreviewNormal ctermbg=239 guibg=#504945"
                vim.cmd.highlight "TelescopePreviewTitle ctermbg=239 guibg=#504945"
            else
                vim.cmd.highlight "Cursor cterm=NONE ctermfg=230 ctermbg=234 gui=NONE guifg=#f9f5d7 guibg=#1d2021"
                vim.cmd.highlight "CursorLine ctermbg=230 guibg=#f9f5d7"
                vim.cmd.highlight "CursorLineNr ctermbg=229 guibg=#fbf1c7"
                vim.cmd.highlight "FoldColumn ctermbg=229 guibg=#fbf1c7"
                vim.cmd.highlight "IndentBlanklineChar cterm=nocombine ctermfg=228 gui=nocombine guifg=#f2e5bc"
                vim.cmd.highlight "MatchParen ctermbg=223 guibg=#ebdbb2"
                vim.cmd.highlight "TelescopePromptBorder ctermbg=228 guibg=#f2e5bc"
                vim.cmd.highlight "TelescopePromptNormal ctermbg=228 guibg=#f2e5bc"
                vim.cmd.highlight "TelescopePromptTitle ctermbg=228 guibg=#f2e5bc"
                vim.cmd.highlight "TelescopeResultsBorder ctermbg=223 guibg=#ebdbb2"
                vim.cmd.highlight "TelescopeResultsNormal ctermbg=223 guibg=#ebdbb2"
                vim.cmd.highlight "TelescopeResultsTitle ctermbg=223 guibg=#ebdbb2"
                vim.cmd.highlight "TelescopePreviewBorder ctermbg=250 guibg=#d5c4a1"
                vim.cmd.highlight "TelescopePreviewNormal ctermbg=250 guibg=#d5c4a1"
                vim.cmd.highlight "TelescopePreviewTitle ctermbg=250 guibg=#d5c4a1"
            end
            vim.cmd "highlight! link HopNextKey GruvboxGreenBold"
            vim.cmd "highlight! link HopNextKey1 GruvboxAquaBold"
            vim.cmd "highlight! link HopNextKey2 GruvboxBlue"
            vim.cmd "highlight! link HopUnmatched GruvboxBg2"
        end

        vim.g.gruvbox_invert_selection = 0
        vim.g.gruvbox_italic = 1
        vim.g.gruvbox_sign_column = "none"
        setup()

        require("which-key").register {
            ["<leader>t"] = {
                name = "toggle",
                t = {
                    function()
                        vim.o.background = vim.o.background ~= "dark" and "dark" or "light"
                        setup()
                    end,
                    "Toggle theme",
                },
            },
        }
    end,
}
