return {
    "ellisonleao/gruvbox.nvim",
    enabled = not vim.g.vscode,
    priority = 1000,
    dependencies = "folke/which-key.nvim",
    config = function()
        local function setup()
            local colors = (require "gruvbox.palette").colors
            local bg = vim.o.background
            local fg = bg == "dark" and "light" or "dark"

            require("gruvbox").setup {
                italic = {
                    strings = false,
                },
                overrides = {
                    Comment = { italic = true },
                    CursorLine = { bg = bg == "dark" and colors.dark0_soft or colors.light0_hard },
                    CursorLineNr = { bg = colors[bg .. "0"] },
                    EyelinerPrimary = { bold = true, underline = true },
                    EyelinerSecondary = { bold = true },
                    FoldColumn = { bg = colors[bg .. "0"] },
                    GruvboxAquaSign = { bg = colors[bg .. "0"] },
                    GruvboxBlueSign = { bg = colors[bg .. "0"] },
                    GruvboxGreenSign = { bg = colors[bg .. "0"] },
                    GruvboxOrangeSign = { bg = colors[bg .. "0"] },
                    GruvboxPurpleSign = { bg = colors[bg .. "0"] },
                    GruvboxRedSign = { bg = colors[bg .. "0"] },
                    GruvboxYellowSign = { bg = colors[bg .. "0"] },
                    IlluminatedWordRead = { bg = colors[bg .. "2"] },
                    IlluminatedWordText = { bg = colors[bg .. "2"] },
                    IlluminatedWordWrite = { bg = bg == "dark" and colors.faded_orange or colors.bright_yellow },
                    LeapBackdrop = { fg = colors.gray, bg = colors[bg .. "0"] },
                    LeapLabelPrimary = { nocombine = true, fg = colors.light0, bg = colors.neutral_red },
                    LeapLabelSecondary = { nocombine = true, fg = colors.light0, bg = colors.faded_blue },
                    LeapMatch = { fg = colors[fg .. "0"] },
                    MatchParen = { bold = false, bg = colors[bg .. "2"] },
                    SignColumn = { bg = colors[bg .. "0"] },
                    TelescopePreviewBorder = { bg = colors[bg .. "2"] },
                    TelescopePreviewNormal = { bg = colors[bg .. "2"] },
                    TelescopePreviewTitle = { bg = colors[bg .. "2"] },
                    TelescopePromptBorder = { bg = colors[bg .. "0_soft"] },
                    TelescopePromptNormal = { bg = colors[bg .. "0_soft"] },
                    TelescopePromptTitle = { bg = colors[bg .. "0_soft"] },
                    TelescopeResultsBorder = { bg = colors[bg .. "1"] },
                    TelescopeResultsNormal = { bg = colors[bg .. "1"] },
                    TelescopeResultsTitle = { bg = colors[bg .. "1"] },
                    TreesitterContextLineNumber = { fg = colors.gray, bg = colors[bg .. "2"] },
                    Whitespace = { fg = bg == "dark" and colors.dark0_hard or colors.light0_soft },
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
