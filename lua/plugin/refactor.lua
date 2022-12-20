return {
    "ThePrimeagen/refactoring.nvim",
    requires = {
        "folke/which-key.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        local wk = require "which-key"
        local re = require "refactoring"

        re.setup {}

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("RefactoringSetup", { clear = true }),
            pattern = { "c", "cpp", "go", "java", "javascript", "lua", "php", "python", "ruby", "typescript" },
            callback = function(opts)
                wk.register({
                    ["<leader>r"] = {
                        name = "refactor",
                        B = {
                            function()
                                re.refactor "Extract Block To File"
                            end,
                            "Extract block to file",
                        },
                        E = {
                            function()
                                re.refactor "Extract Function To File"
                            end,
                            "Extract function to file",
                        },
                        b = {
                            function()
                                re.refactor "Extract Block"
                            end,
                            "Extract block",
                        },
                        e = {
                            function()
                                re.refactor "Extract Function"
                            end,
                            "Extract function",
                        },
                        i = {
                            function()
                                re.refactor "Inline Variable"
                            end,
                            "Inline variable",
                        },
                        v = {
                            function()
                                re.refactor "Extract Variable"
                            end,
                            "Extract variable",
                        },
                    },
                }, { buffer = opts.buf, mode = "v" })
                wk.register({
                    ["<leader>r"] = {
                        name = "refactor",
                        B = {
                            function()
                                re.refactor "Extract Block To File"
                            end,
                            "Extract block to file",
                        },
                        b = {
                            function()
                                re.refactor "Extract Block"
                            end,
                            "Extract block",
                        },
                        i = {
                            function()
                                re.refactor "Inline Variable"
                            end,
                            "Inline variable",
                        },
                    },
                }, { buffer = opts.buf, mode = "n" })
            end,
        })
    end,
}
