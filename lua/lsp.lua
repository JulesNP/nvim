return {
    "VonHeikemen/lsp-zero.nvim",
    requires = {
        -- LSP Support
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        { "jose-elias-alvarez/null-ls.nvim" },

        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "folke/lua-dev.nvim" },

        -- Snippets
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets" },
    },
    config = function()
        local lsp = require "lsp-zero"
        lsp.set_preferences {
            suggest_lsp_servers = true,
            setup_servers_on_start = true,
            set_lsp_keymaps = false,
            configure_diagnostics = false,
            cmp_capabilities = true,
            manage_nvim_cmp = false,
            call_servers = "local",
            sign_icons = {
                error = "✘",
                warn = "▲",
                hint = "⚑",
                info = "",
            },
        }

        local luadev = require("lua-dev").setup {}
        lsp.configure("sumneko_lua", luadev)

        require("null-ls").setup {
            sources = {
                require("null-ls").builtins.formatting.stylua,
            },
        }

        lsp.setup()
    end,
}
