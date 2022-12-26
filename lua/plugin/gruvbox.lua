return {
    "ellisonleao/gruvbox.nvim",
    requires = "folke/which-key.nvim",
    config = function()
        local function setup()
            local palette = require "gruvbox.palette"
            local bg = vim.o.background
            local fg = bg == "dark" and "light" or "dark"
            local blankline = { fg = bg == "dark" and palette.dark0_hard or palette.light0_soft }

            require("gruvbox").setup {
                italic = false,
                overrides = {
                    Comment = { italic = true },
                    CursorLine = { bg = bg == "dark" and palette.dark0_soft or palette.light0_hard },
                    CursorLineNr = { bg = palette[bg .. "0"] },
                    EyelinerPrimary = { bold = true, underline = true },
                    EyelinerSecondary = { bold = true },
                    FoldColumn = { bg = palette[bg .. "0"] },
                    GruvboxAquaSign = { bg = palette[bg .. "0"] },
                    GruvboxBlueSign = { bg = palette[bg .. "0"] },
                    GruvboxGreenSign = { bg = palette[bg .. "0"] },
                    GruvboxOrangeSign = { bg = palette[bg .. "0"] },
                    GruvboxPurpleSign = { bg = palette[bg .. "0"] },
                    GruvboxRedSign = { bg = palette[bg .. "0"] },
                    GruvboxYellowSign = { bg = palette[bg .. "0"] },
                    IlluminatedWordRead = { bg = palette[bg .. "2"] },
                    IlluminatedWordText = { bg = palette[bg .. "2"] },
                    IlluminatedWordWrite = { bold = true, bg = palette[bg .. "3"] },
                    IndentBlanklineChar = blankline,
                    IndentBlanklineSpaceChar = blankline,
                    IndentBlanklineSpaceCharBlankline = blankline,
                    LeapBackdrop = { fg = palette.gray, bg = palette[bg .. "0"] },
                    LeapLabelPrimary = { nocombine = true, fg = palette[fg .. "0"], bg = palette.neutral_red },
                    LeapLabelSecondary = { nocombine = true, fg = palette[fg .. "0"], bg = palette.faded_blue },
                    LeapMatch = { fg = palette[fg .. "0"] },
                    MatchParen = { bg = palette[bg .. "1"] },
                    SignColumn = { bg = palette[bg .. "0"] },
                    TelescopePreviewBorder = { bg = palette[bg .. "2"] },
                    TelescopePreviewNormal = { bg = palette[bg .. "2"] },
                    TelescopePreviewTitle = { bg = palette[bg .. "2"] },
                    TelescopePromptBorder = { bg = palette[bg .. "0_soft"] },
                    TelescopePromptNormal = { bg = palette[bg .. "0_soft"] },
                    TelescopePromptTitle = { bg = palette[bg .. "0_soft"] },
                    TelescopeResultsBorder = { bg = palette[bg .. "1"] },
                    TelescopeResultsNormal = { bg = palette[bg .. "1"] },
                    TelescopeResultsTitle = { bg = palette[bg .. "1"] },
                },
            }
            vim.cmd.colorscheme "gruvbox"
        end

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
