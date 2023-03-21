return {
    "itchyny/vim-qfedit",
    cond = not vim.g.vscode,
    ft = "qf",
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("QFMappings", { clear = true }),
            pattern = "qf",
            callback = function()
                local function map(key, func, desc)
                    vim.keymap.set("n", key, func, { desc = desc, buffer = 0 })
                end
                map("<c-s>", "<c-w><cr><c-w>K", "Open item in horizontal split")
                map("<c-v>", "<c-w><cr><c-w>H<c-w>p<c-w>J<c-w>p", "Open item in vertical split")
                map("<leader>q", vim.cmd.cclose, "Close quickfix list")
                map("<tab>", "<cr><c-w>p", "Open item but stay in quickfix list")
                map("[[", function()
                    pcall(vim.cmd.colder)
                end, "Switch to older quickfix list")
                map("]]", function()
                    pcall(vim.cmd.cnewer)
                end, "Switch to newer quickfix list")
                map("{", "<cmd>cpfile<cr><c-w>p", "Move to previous file")
                map("}", "<cmd>cnfile<cr><c-w>p", "Move to next file")
                map("o", "<cr><cmd>cclose<cr>", "Open item and close quickfix list")
                map("q", vim.cmd.cclose, "Close quickfix list")
            end,
        })
    end,
}
