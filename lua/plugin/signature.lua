return {
    "ray-x/lsp_signature.nvim",
    config = function()
        require("lsp_signature").setup {
            bind = true,
            handler_opts = {
                border = "none",
            },
            hint_prefix = "↳ ",
            hint_scheme = "DiagnosticHint",
            select_signature_key = "<m-o>",
        }
    end,
}
