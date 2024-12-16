local filetypes = { "c", "cpp", "cs", "go", "java", "javascript", "lua", "php", "python", "ruby", "typescript" }
return {
    "ThePrimeagen/refactoring.nvim",
    cond = not vim.g.vscode,
    ft = filetypes,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        local refactoring = require "refactoring"

        refactoring.setup {
            prompt_func_return_type = {
                go = true,
                cpp = true,
                c = true,
                java = true,
            },
            prompt_func_param_type = {
                go = true,
                cpp = true,
                c = true,
                java = true,
            },
            show_success_message = true,
        }

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("RefactoringSetup", { clear = true }),
            pattern = filetypes,
            callback = function()
                vim.keymap.set({ "n", "x" }, "grf", function()
                    refactoring.select_refactor {}
                end)
            end,
        })
    end,
}
