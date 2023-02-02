return {
    "nmac427/guess-indent.nvim",
    config = function()
        require("guess-indent").setup {
            auto_cmd = false,
        }

        local function update_indent()
            vim.cmd "silent GuessIndent"
            vim.wo.listchars = "tab:> ,nbsp:+,multispace:▏" .. string.rep(" ", vim.bo.shiftwidth - 1)
        end

        local guess_indent = vim.api.nvim_create_augroup("GuessIndent", { clear = true })

        vim.api.nvim_create_autocmd("BufReadPost", {
            group = guess_indent,
            pattern = "*",
            callback = update_indent,
        })
        vim.api.nvim_create_autocmd("BufNewFile", {
            group = guess_indent,
            pattern = "*",
            callback = function(opts)
                vim.api.nvim_create_autocmd("BufWritePost", {
                    group = guess_indent,
                    buffer = opts.buf,
                    once = true,
                    callback = update_indent,
                })
            end,
        })
    end,
}
