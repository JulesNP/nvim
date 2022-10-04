return {
    "TimUntersberger/neogit",
    requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
        local neogit = require "neogit"
        neogit.setup {
            disable_commit_confirmation = true,
            disable_context_highlighting = true,
            disable_insert_on_commit = false,
            integrations = {
                diffview = true,
            },
        }
        require("which-key").register {
            ["<leader>gg"] = {
                function()
                    neogit.open { cwd = (vim.fn.expand "%:p:h") }
                end,
                "Neogit",
            },
            ["<leader>c"] = {
                function()
                    neogit.open { "commit", cwd = (vim.fn.expand "%:p:h") }
                end,
                "Create commit",
            },
        }
    end,
}
