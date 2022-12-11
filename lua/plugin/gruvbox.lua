return {
    "gruvbox-community/gruvbox",
    requires = "folke/which-key.nvim",
    config = function()
        local function setup()
            vim.cmd.colorscheme "gruvbox"
            if vim.o.background == "dark" then
                vim.cmd.highlight "Cursor gui=NONE guifg=#1d2021 guibg=#f9f5d7"
                vim.cmd.highlight "CursorLine guibg=#32302f"
                vim.cmd.highlight "CursorLineNr guibg=#282828"
                vim.cmd.highlight "FoldColumn guibg=#282828"
                vim.cmd.highlight "IndentBlanklineChar gui=nocombine guifg=#1d2021"
                vim.cmd.highlight "MatchParen guibg=#3c3836"
                vim.cmd.highlight "TelescopePromptBorder guibg=#32302f"
                vim.cmd.highlight "TelescopePromptNormal guibg=#32302f"
                vim.cmd.highlight "TelescopePromptTitle guibg=#32302f"
                vim.cmd.highlight "TelescopeResultsBorder guibg=#3c3836"
                vim.cmd.highlight "TelescopeResultsNormal guibg=#3c3836"
                vim.cmd.highlight "TelescopeResultsTitle guibg=#3c3836"
                vim.cmd.highlight "TelescopePreviewBorder guibg=#504945"
                vim.cmd.highlight "TelescopePreviewNormal guibg=#504945"
                vim.cmd.highlight "TelescopePreviewTitle guibg=#504945"
                vim.cmd.highlight "LeapBackdrop guifg=#928374 guibg=#282828"
                vim.cmd.highlight "LeapMatch guifg=#fbf1c7"
            else
                vim.cmd.highlight "Cursor gui=NONE guifg=#f9f5d7 guibg=#1d2021"
                vim.cmd.highlight "CursorLine guibg=#f9f5d7"
                vim.cmd.highlight "CursorLineNr guibg=#fbf1c7"
                vim.cmd.highlight "FoldColumn guibg=#fbf1c7"
                vim.cmd.highlight "IndentBlanklineChar gui=nocombine guifg=#f2e5bc"
                vim.cmd.highlight "MatchParen guibg=#ebdbb2"
                vim.cmd.highlight "TelescopePromptBorder guibg=#f2e5bc"
                vim.cmd.highlight "TelescopePromptNormal guibg=#f2e5bc"
                vim.cmd.highlight "TelescopePromptTitle guibg=#f2e5bc"
                vim.cmd.highlight "TelescopeResultsBorder guibg=#ebdbb2"
                vim.cmd.highlight "TelescopeResultsNormal guibg=#ebdbb2"
                vim.cmd.highlight "TelescopeResultsTitle guibg=#ebdbb2"
                vim.cmd.highlight "TelescopePreviewBorder guibg=#d5c4a1"
                vim.cmd.highlight "TelescopePreviewNormal guibg=#d5c4a1"
                vim.cmd.highlight "TelescopePreviewTitle guibg=#d5c4a1"
                vim.cmd.highlight "LeapBackdrop guifg=#928374 guibg=#fbf1c7"
                vim.cmd.highlight "LeapMatch guifg=#1d2021"
            end
            vim.cmd.highlight "EyelinerPrimary gui=bold,underline"
            vim.cmd.highlight "EyelinerSecondary gui=bold"
            vim.cmd.highlight "LeapLabelPrimary gui=nocombine guifg=#fbf1c7 guibg=#cc241d"
            vim.cmd.highlight "LeapLabelSecondary gui=nocombine guifg=#fbf1c7 guibg=#458588"
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
