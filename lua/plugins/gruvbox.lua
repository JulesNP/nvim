return {
    "ellisonleao/gruvbox.nvim",
    cond = not vim.g.vscode,
    priority = 1000,
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
                    CursorLine = { bg = bg == "dark" and colors.dark0_soft or colors.light0_hard },
                    CursorLineNr = { bg = colors[bg .. "0"] },
                    EyelinerPrimary = { bold = true, underline = true },
                    EyelinerSecondary = { bold = true },
                    Folded = { italic = false },
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
                    IndentBlanklineChar = {
                        fg = bg == "dark" and colors.dark0_hard or colors.light0_soft,
                        nocombine = true,
                    },
                    IndentBlanklineSpaceChar = {
                        fg = bg == "dark" and colors.bright_orange or colors.faded_orange,
                        nocombine = true,
                    },
                    FlashLabel = { nocombine = true, fg = colors.light0_hard, bg = colors.faded_blue },
                    MatchParen = { bg = colors[bg .. "2"] },
                    MiniIndentscopeSymbol = { fg = colors[bg .. "2"] },
                    SignColumn = { bg = colors[bg .. "0"] },
                    TelescopePreviewBorder = { link = "TelescopePreviewNormal" },
                    TelescopePreviewNormal = { bg = colors[bg .. "2"] },
                    TelescopePreviewTitle = { link = "TelescopePreviewNormal" },
                    TelescopePromptBorder = { link = "TelescopePromptNormal" },
                    TelescopePromptNormal = { bg = colors[bg .. "0_soft"] },
                    TelescopePromptTitle = { link = "TelescopePromptNormal" },
                    TelescopeResultsBorder = { link = "TelescopeResultsNormal" },
                    TelescopeResultsNormal = { bg = colors[bg .. "1"] },
                    TelescopeResultsTitle = { link = "TelescopeResultsNormal" },
                    TreesitterContext = {
                        fg = colors[fg .. "1"],
                        bg = colors[bg .. "1"],
                        blend = 12,
                    },
                    TreesitterContextLineNumber = { fg = colors.gray, bg = colors[bg .. "1"] },
                },
            }
            vim.cmd.colorscheme "gruvbox"
        end

        setup()

        vim.keymap.set("n", "<leader>tt", function()
            vim.o.background = vim.o.background ~= "dark" and "dark" or "light"
            setup()
        end, { desc = "Toggle theme" })
    end,
}
