return {
    "kevinhwang91/nvim-ufo",
    cond = not vim.g.vscode,
    dependencies = "kevinhwang91/promise-async",
    config = function()
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local foldLines = endLnum - lnum
            local suffix = (" ...%d line"):format(foldLines)
            if foldLines > 1 then
                suffix = suffix .. "s"
            end
            suffix = suffix .. "..."
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "Comment" })
            return newVirtText
        end
        local ufo = require "ufo"

        ufo.setup {
            enable_get_fold_virt_text = true,
            fold_virt_text_handler = handler,
            open_fold_hl_timeout = 0,
            preview = {
                win_config = {
                    border = "none",
                    winblend = vim.g.neovide and 25 or 0,
                    winhighlight = "Normal:NormalFloat",
                },
                mappings = {
                    close = "q",
                    scrollE = "<c-e>",
                    scrollY = "<c-y>",
                    switch = "K",
                    trace = "<cr>",
                },
            },
            provider_selector = function()
                return { "lsp", "indent" }
            end,
        }

        vim.keymap.set("n", "zJ", ufo.goNextClosedFold, { desc = "Next closed fold" })
        vim.keymap.set("n", "zK", ufo.goPreviousClosedFold, { desc = "Previours closed fold" })
        vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
        vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
        vim.keymap.set("n", "zk", ufo.goPreviousStartFold, { desc = "Start of previous fold" })
    end,
}
