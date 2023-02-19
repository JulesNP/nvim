return {
    "lvimuser/lsp-inlayhints.nvim",
    requires = "folke/which-key.nvim",
    config = function()
        local inlay = require "lsp-inlayhints"
        inlay.setup {}

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

                require("which-key").register {
                    ["<leader>th"] = { inlay.toggle, "Toggle LSP inlay hints" },
                }
            end,
        })
    end,
}