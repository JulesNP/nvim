return {
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
                    EyelinerPrimary = { bold = true, underline = true },
                    EyelinerSecondary = { bold = true },
                    IlluminatedWordRead = { bg = dark and palette.dark2 or palette.light2 },
                    IlluminatedWordText = { bg = dark and palette.dark2 or palette.light2 },
                    IlluminatedWordWrite = { bg = dark and palette.faded_orange or palette.bright_orange },
                    FlashLabel = {
                        nocombine = true,
                        bold = true,
                        fg = palette.light0_hard,
                        bg = dark and palette.faded_red or palette.bright_red,
                    },
                    MatchParen = { bg = dark and palette.dark2 or palette.light2 },
                    MiniIndentscopeSymbol = { fg = dark and palette.dark2 or palette.light2 },
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
                    Whitespace = { fg = dark and palette.dark1 or palette.light1 },
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
