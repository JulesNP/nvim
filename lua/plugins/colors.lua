return {
    { "Glench/Vim-Jinja2-Syntax", event = { "BufRead", "CmdlineEnter", "InsertEnter" } },
    {
        "ellisonleao/gruvbox.nvim",
        cond = not vim.g.vscode,
        priority = 1000,
        config = function()
            local function setup()
                local dark = vim.o.background == "dark"
                local Gruvbox = require "gruvbox"
                local palette = Gruvbox.palette

                Gruvbox.setup {
                    italic = {
                        comments = true,
                        emphasis = true,
                        folds = false,
                        operators = false,
                        strings = false,
                    },
                    overrides = {
                        CursorLine = { bg = dark and palette.dark0_hard or palette.light0_hard },
                        CursorLineNr = { bg = dark and palette.dark0 or palette.light0 },
                        DiagnosticVirtualTextError = { link = "GruvboxRedSign" },
                        DiagnosticVirtualTextHint = { link = "GruvboxAquaSign" },
                        DiagnosticVirtualTextInfo = { link = "GruvboxBlueSign" },
                        DiagnosticVirtualTextOk = { link = "GruvboxGreenSign" },
                        DiagnosticVirtualTextWarn = { link = "GruvboxYellowSign" },
                        EyelinerPrimary = { bold = true, underline = true },
                        EyelinerSecondary = { bold = true },
                        FlashLabel = {
                            nocombine = true,
                            bold = true,
                            fg = palette.light0_hard,
                            bg = dark and palette.faded_red or palette.bright_red,
                        },
                        FloatBorder = {
                            fg = dark and palette.dark3 or palette.light3,
                            bg = dark and palette.dark1 or palette.light1,
                        },
                        FloatTitle = {
                            bold = true,
                            fg = dark and palette.bright_green or palette.faded_green,
                            bg = dark and palette.dark1 or palette.light1,
                        },
                        IlluminatedWordRead = { bg = dark and palette.dark2 or palette.light2 },
                        IlluminatedWordText = { bg = dark and palette.dark2 or palette.light2 },
                        IlluminatedWordWrite = { bg = dark and palette.faded_orange or palette.bright_orange },
                        IblIndent = { fg = dark and palette.dark0_soft or palette.light0_soft },
                        LspCodeLens = {
                            italic = true,
                            fg = dark and palette.dark2 or palette.light2,
                        },
                        LspCodeLensSeparator = { fg = dark and palette.dark2 or palette.light2 },
                        LspInlayHint = { link = "LspCodeLens" },
                        MatchParen = { bg = dark and palette.dark2 or palette.light2 },
                        MiniDiffSignAdd = { link = "DiffAdd" },
                        MiniDiffSignChange = { link = "DiffChange" },
                        MiniDiffSignDelete = { link = "DiffDelete" },
                        MiniIndentscopeSymbol = { fg = dark and palette.dark2 or palette.light2 },
                        RainbowDelimiterBlue = { link = "GruvboxBlue" },
                        RainbowDelimiterCyan = { link = "GruvboxAqua" },
                        RainbowDelimiterGreen = { link = "GruvboxGreen" },
                        RainbowDelimiterOrange = { link = "GruvboxOrange" },
                        RainbowDelimiterRed = { link = "GruvboxRed" },
                        RainbowDelimiterViolet = { link = "GruvboxPurple" },
                        RainbowDelimiterYellow = { link = "GruvboxYellow" },
                        SignColumn = { link = "LineNr" },
                        StatusLine = {
                            fg = dark and palette.light1 or palette.dark1,
                            bg = dark and palette.dark2 or palette.light2,
                            reverse = false,
                        },
                        StatusLineNC = {
                            fg = dark and palette.light4 or palette.dark4,
                            bg = dark and palette.dark1 or palette.light1,
                            reverse = false,
                        },
                        TabLineSel = { bg = dark and palette.dark0 or palette.light0 },
                        TreesitterContextLineNumber = {
                            fg = palette.gray,
                            bg = dark and palette.dark1 or palette.light1,
                        },
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
    },
    {
        "uga-rosa/ccc.nvim",
        cond = not vim.g.vscode,
        event = { "BufRead", "CmdlineEnter", "InsertEnter" },
        keys = vim.g.vscode and {} or {
            { "<leader>cp", "<cmd>CccPick<cr>", desc = "Color picker" },
        },
        config = function()
            local ccc = require "ccc"
            ccc.setup {
                highlighter = { auto_enable = true, lsp = true },
                inputs = {
                    ccc.input.okhsl,
                    ccc.input.rgb,
                    ccc.input.hsl,
                    ccc.input.cmyk,
                },
            }
        end,
    },
}
