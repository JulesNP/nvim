local filetypes = { "c", "cpp", "go", "java", "javascript", "lua", "php", "python", "ruby", "typescript" }
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

        re.setup {}

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("RefactoringSetup", { clear = true }),
            pattern = filetypes,
            callback = function(opts)
                local function map(mode, key, desc)
                    vim.keymap.set(mode, key, function()
                        re.refactor(desc)
                    end, { desc = desc, buffer = opts.buf })
                end

                map("x", "<leader>rf", "Extract Function")
                map("x", "<leader>rF", "Extract Function To File")
                map("x", "<leader>rv", "Extract Variable")
                map("n", "<leader>rI", "Inline Function")
                map({ "n", "x" }, "<leader>ri", "Inline Variable")
                map("n", "<leader>rb", "Extract Block")
                map("n", "<leader>rB", "Extract Block To File")
            end,
        })
    end,
}
