return {
    "ellisonleao/gruvbox.nvim",
    cond = not vim.g.vscode,
    priority = 1000,
    config = function()
        local function setup()
            local bg = vim.o.background
            local fg = bg == "dark" and "light" or "dark"

            local palette = require "gruvbox.palette"
            local neutral = palette.get_base_colors({}, nil, "")
            local soft = palette.get_base_colors({}, nil, "soft")
            local hard = palette.get_base_colors({}, nil, "hard")
            local opposite = palette.get_base_colors({}, fg, "")

            require("gruvbox").setup {
                italic = {
                    strings = false,
                },
                overrides = {
                    CursorLine = { bg = bg == "dark" and soft.bg0 or hard.bg0 },
                    CursorLineNr = { bg = neutral.bg0 },
                    EyelinerPrimary = { bold = true, underline = true },
                    EyelinerSecondary = { bold = true },
                    Folded = { italic = false },
                    FoldColumn = { bg = neutral.bg0 },
                    GruvboxAquaSign = { bg = neutral.bg0 },
                    GruvboxBlueSign = { bg = neutral.bg0 },
                    GruvboxGreenSign = { bg = neutral.bg0 },
                    GruvboxOrangeSign = { bg = neutral.bg0 },
                    GruvboxPurpleSign = { bg = neutral.bg0 },
                    GruvboxRedSign = { bg = neutral.bg0 },
                    GruvboxYellowSign = { bg = neutral.bg0 },
                    IlluminatedWordRead = { bg = neutral.bg2 },
                    IlluminatedWordText = { bg = neutral.bg2 },
                    IlluminatedWordWrite = { bg = bg == "dark" and opposite.orange or opposite.yellow },
                    IblIndent = {
                        fg = bg == "dark" and hard.bg0 or soft.bg0,
                        nocombine = true,
                    },
                    IblWhitespace = {
                        fg = neutral.orange,
                        nocombine = true,
                    },
                    FlashLabel = {
                        nocombine = true,
                        bold = true,
                        fg = bg == "dark" and hard.fg0 or hard.bg0,
                        bg = bg == "dark" and opposite.red or neutral.red,
                    },
                    MatchParen = { bg = neutral.bg2 },
                    MiniIndentscopeSymbol = { fg = neutral.bg2 },
                    NeoGitDiffAdd = { bg = opposite.green },
                    NeoGitDiffAddHighlight = { bg = neutral.neutral_green },
                    NeoGitDiffDelete = { bg = opposite.red },
                    NeoGitDiffDeleteHighlight = { bg = neutral.neutral_red },
                    SignColumn = { bg = neutral.bg0 },
                    TelescopePreviewBorder = { link = "TelescopePreviewNormal" },
                    TelescopePreviewNormal = { bg = neutral.bg2 },
                    TelescopePreviewTitle = { link = "TelescopePreviewNormal" },
                    TelescopePromptBorder = { link = "TelescopePromptNormal" },
                    TelescopePromptNormal = { bg = soft.bg0 },
                    TelescopePromptTitle = { link = "TelescopePromptNormal" },
                    TelescopeResultsBorder = { link = "TelescopeResultsNormal" },
                    TelescopeResultsNormal = { bg = neutral.bg1 },
                    TelescopeResultsTitle = { link = "TelescopeResultsNormal" },
                    TreesitterContext = {
                        fg = neutral.fg1,
                        bg = neutral.bg1,
                        blend = 12,
                    },
                    TreesitterContextLineNumber = { fg = neutral.gray, bg = neutral.bg1 },
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
