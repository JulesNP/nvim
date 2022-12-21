return {
    "nvim-treesitter/nvim-treesitter",
    requires = {
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "andymass/vim-matchup",
        "windwp/nvim-ts-autotag",
    },
    run = function()
        require("nvim-treesitter.install").update { with_sync = true }
    end,
    config = function()
        require("nvim-treesitter.configs").setup {
            highlight = {
                enable = not vim.g.vscode,
                disable = { "pug" },
            },
            autotag = {
                enable = not vim.g.vscode,
            },
            ensure_installed = "all",
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gs",
                    node_incremental = "<tab>",
                    node_decremental = "<bs>",
                },
            },
            matchup = {
                enable = not vim.g.vscode,
            },
            textobjects = {
                lsp_interop = {
                    enable = true,
                    border = "none",
                    peek_definition_code = {
                        ["<leader>k"] = "@function.outer",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]?"] = "@conditional.outer",
                        ["]]"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                        ["]l"] = "@loop.outer",
                        ["]m"] = "@function.outer",
                    },
                    goto_next_end = {
                        ["]/"] = "@comment.outer",
                        ["]A"] = "@parameter.inner",
                        ["]L"] = "@loop.outer",
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[/"] = "@comment.outer",
                        ["[?"] = "@conditional.outer",
                        ["[["] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                        ["[l"] = "@loop.outer",
                        ["[m"] = "@function.outer",
                    },
                    goto_previous_end = {
                        ["[A"] = "@parameter.inner",
                        ["[L"] = "@loop.outer",
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["a/"] = "@comment.outer",
                        ["a?"] = "@conditional.outer",
                        ["a@"] = "@attribute.outer",
                        ["aC"] = "@class.outer",
                        ["aF"] = "@frame.outer",
                        ["aS"] = "@statement.outer",
                        ["aa"] = "@parameter.outer",
                        ["ac"] = "@call.outer",
                        ["af"] = "@function.outer",
                        ["ak"] = "@block.outer",
                        ["al"] = "@loop.outer",
                        ["i?"] = "@conditional.inner",
                        ["i@"] = "@attribute.inner",
                        ["iC"] = "@class.inner",
                        ["iF"] = "@frame.inner",
                        ["iS"] = "@statement.inner",
                        ["ia"] = "@parameter.inner",
                        ["ic"] = "@call.inner",
                        ["if"] = "@function.inner",
                        ["ik"] = "@block.inner",
                        ["il"] = "@loop.inner",
                    },
                    include_surrounding_whitespace = true,
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
            require("treesitter-context").setup {
                trim_scope = "inner",
            }
        end
    end,
}
