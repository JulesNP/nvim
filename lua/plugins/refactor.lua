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
        local re = require "refactoring"

        re.setup {
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
            callback = function(opts)
                local function map(mode, key, desc)
                    vim.keymap.set(mode, key, function()
                        re.refactor(desc)
                    end, { desc = desc, buffer = opts.buf })
                end

                map("x", "grm", "Extract Function")
                map("x", "grf", "Extract Function To File")
                map("x", "grv", "Extract Variable")
                map("n", "grM", "Inline Function")
                map({ "n", "x" }, "grV", "Inline Variable")
                map("n", "grb", "Extract Block")
                map("n", "grf", "Extract Block To File")
            end,
        })
    end,
}
