return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "CmdlineEnter", "InsertEnter" },
    dependencies = {
        "HiPhish/rainbow-delimiters.nvim",
        "andymass/vim-matchup",
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "windwp/nvim-ts-autotag",
    },
    build = function()
        local ts_update = require("nvim-treesitter.install").update { with_sync = true }
        ts_update()
    end,
    init = function()
        vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_matchparen_offscreen = {}
    end,
    config = function()
        require("nvim-treesitter.configs").setup { ---@diagnostic disable-line: missing-fields
            auto_install = vim.fn.executable "tree-sitter" == 1,
            highlight = {
                enable = not vim.g.vscode,
                disable = { "csv" }, -- Conflicts with rainbow_csv
                additional_vim_regex_highlighting = { "sql" },
            },
            indent = {
                enable = not vim.g.vscode,
                disable = { "fsharp" },
            },
            matchup = {
                enable = not vim.g.vscode,
            },
            textobjects = {
                lsp_interop = {
                    enable = true,
                    border = "rounded",
                    peek_definition_code = {
                        ["<leader>k"] = "@function.outer",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]a"] = "@parameter.inner",
                    },
                    goto_next_end = {
                        ["]A"] = "@parameter.inner",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[a"] = "@parameter.inner",
                    },
                    goto_previous_end = {
                        ["[A"] = "@parameter.inner",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
            },
        }

        if not vim.g.vscode then
            require("nvim-ts-autotag").setup {}

            require("treesitter-context").setup {
                multiwindow = true,
                trim_scope = "inner",
            }

            require("rainbow-delimiters.setup").setup { blacklist = { "comment" } }
        end
    end,
}
