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
                local function map(mode, key, func, desc)
                    vim.keymap.set(mode, key, func, { desc = desc, buffer = opts.buf })
                end
                map("n", "<leader>rB", function()
                    re.refactor "Extract Block To File"
                end, "Extract block to file")
                map("n", "<leader>rb", function()
                    re.refactor "Extract Block"
                end, "Extract block")
                map("n", "<leader>ri", function()
                    re.refactor "Inline Variable"
                end, "Inline variable")
                map("x", "<leader>rB", function()
                    re.refactor "Extract Block To File"
                end, "Extract block to file")
                map("x", "<leader>rE", function()
                    re.refactor "Extract Function To File"
                end, "Extract function to file")
                map("x", "<leader>rb", function()
                    re.refactor "Extract Block"
                end, "Extract block")
                map("x", "<leader>re", function()
                    re.refactor "Extract Function"
                end, "Extract function")
                map("x", "<leader>ri", function()
                    re.refactor "Inline Variable"
                end, "Inline variable")
                map("x", "<leader>rv", function()
                    re.refactor "Extract Variable"
                end, "Extract variable")
            end,
        })
    end,
}
