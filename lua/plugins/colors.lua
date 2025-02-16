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

                ---@diagnostic disable-next-line: missing-fields
                Gruvbox.setup {
                    italic = {
                        comments = true,
                        emphasis = true,
                        folds = false,
                        operators = false,
                        strings = false,
                    },
                    overrides = {
                        BlinkCmpGhostText = { link = "Comment" },
                        EyelinerPrimary = { bold = true, underline = true },
                        EyelinerSecondary = { bold = true },
                        FlashLabel = {
                            nocombine = true,
                            bold = true,
                            fg = palette.light0_hard,
                            bg = palette.neutral_red,
                        },
                        FloatBorder = { fg = palette.gray, bg = dark and palette.dark1 or palette.light1 },
                        IlluminatedWordRead = { link = "MatchWord" },
                        IlluminatedWordText = { link = "MatchWord" },
                        IlluminatedWordWrite = {
                            bg = dark and palette.dark3 or palette.light3,
                            bold = true,
                            underline = true,
                        },
                        LspCodeLens = { italic = true, fg = palette.gray },
                        MiniDiffSignAdd = { link = "DiffAdd" },
                        MiniDiffSignChange = { link = "DiffChange" },
                        MiniDiffSignDelete = { link = "DiffDelete" },
                        RenderMarkdownCode = { bg = dark and palette.dark0_soft or palette.light0_soft },
                        RenderMarkdownCodeInline = { bg = dark and palette.dark0_soft or palette.light0_soft },
                        SnacksIndent = { fg = dark and palette.dark0_soft or palette.light0_soft },
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
