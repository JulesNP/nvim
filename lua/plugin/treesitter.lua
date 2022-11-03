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
                enable = true,
                additional_vim_regex_highlighting = true,
            },
            autotag = {
                enable = true,
            },
            ensure_installed = { "lua", "org" },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<cr>",
                    node_incremental = "<tab>",
                    node_decremental = "<s-tab>",
                },
            },
            matchup = {
                enable = true,
            },
            textobjects = {
                lsp_interop = {
                    enable = true,
                    border = "none",
                    peek_definition_code = {
                        ["<leader>d"] = "@function.outer",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]/"] = "@comment.outer",
                        ["]?"] = "@conditional.inner",
                        ["]]"] = "@class.outer",
                        ["]a"] = "@parameter.inner",
                        ["]l"] = "@loop.inner",
                        ["]m"] = "@function.outer",
                    },
                    goto_next_end = {
                        ["]A"] = "@parameter.inner",
                        ["]L"] = "@loop.inner",
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[/"] = "@comment.outer",
                        ["[?"] = "@conditional.inner",
                        ["[["] = "@class.outer",
                        ["[a"] = "@parameter.inner",
                        ["[l"] = "@loop.inner",
                        ["[m"] = "@function.outer",
                    },
                    goto_previous_end = {
                        ["[A"] = "@parameter.inner",
                        ["[L"] = "@loop.inner",
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["ac"] = "@call.outer",
                        ["ic"] = "@call.inner",
                        ["a/"] = "@comment.outer",
                        ["i/"] = "@comment.inner",
                        ["a?"] = "@conditional.outer",
                        ["i?"] = "@conditional.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["al"] = "@loop.outer",
                        ["il"] = "@loop.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
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

        require("treesitter-context").setup {
            trim_scope = "inner",
        }
    end,
}
