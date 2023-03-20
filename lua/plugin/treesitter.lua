return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "andymass/vim-matchup",
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/playground",
    },
    run = function()
        local ts_update = require("nvim-treesitter.install").update { with_sync = true }
        ts_update()
    end,
    config = function()
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        parser_config.fsharp = {
            install_info = {
                url = "https://github.com/Nsidorenco/tree-sitter-fsharp",
                branch = "develop",
                files = { "src/scanner.cc", "src/parser.c" },
            },
            filetype = "fsharp",
        }

        require("nvim-treesitter.configs").setup {
            highlight = {
                enable = not vim.g.vscode,
            },
            ensure_installed = {
                "c_sharp",
                "cmake",
                "erlang",
                "help",
                "julia",
                "lua",
                "markdown",
                "markdown_inline",
                "org",
                "slint",
                "tsx",
                "typescript",
                "vim",
            },
            auto_install = true,
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
            playground = {
                enable = not vim.g.vscode,
                disable = {},
                updatetime = 25,
                persist_queries = false,
                keybindings = {
                    toggle_query_editor = "o",
                    toggle_hl_groups = "i",
                    toggle_injected_languages = "t",
                    toggle_anonymous_nodes = "a",
                    toggle_language_display = "I",
                    focus_language = "f",
                    unfocus_language = "F",
                    update = "R",
                    goto_node = "<cr>",
                    show_help = "?",
                },
            },
            query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = { "BufWrite", "CursorHold" },
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

        vim.keymap.set(
            "n",
            "<leader>tk",
            "<cmd>TSHighlightCapturesUnderCursor<cr>",
            { desc = "View treesitter highlights" }
        )
        vim.keymap.set("n", "<leader>tn", "<cmd>TSNodeUnderCursor<cr>", { desc = "View treesitter node" })
        vim.keymap.set("n", "<leader>tp", "<cmd>TSPlaygroundToggle<cr>", { desc = "Toggle treesitter playground" })
    end,
}
