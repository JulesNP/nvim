return {
    "TimUntersberger/neogit",
    requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
        local neogit = require "neogit"
        neogit.setup {
            disable_commit_confirmation = true,
            disable_insert_on_commit = false,
            integrations = {
                diffview = true,
            },
        }
        require("which-key").register {
            ["<leader>g"] = {
                name = "git",
                g = { neogit.open, "Neogit status" },
                c = {
                    function()
                        neogit.open { "commit" }
                    end,
                    "Create commit",
                },
            },
        }
    end,
}
