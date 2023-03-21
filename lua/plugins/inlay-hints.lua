return {
    "lvimuser/lsp-inlayhints.nvim",
    cond = not vim.g.vscode,
    event = "LspAttach",
    config = function()
        local inlay = require "lsp-inlayhints"
        inlay.setup {
            enabled_at_startup = false,
        }

        local inlay_group = vim.api.nvim_create_augroup("InlayHints", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
            group = inlay_group,
            callback = function(args)
                if not (args.data and args.data.client_id) then
                    return
                end
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                inlay.on_attach(client, bufnr, false)

                vim.keymap.set("n", "<leader>th", inlay.toggle, { desc = "Toggle LSP inlay hints" })
            end,
        })
    end,
}
