return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "CmdlineEnter", "InsertEnter" },
    dependencies = {
        "HiPhish/rainbow-delimiters.nvim",
        "andymass/vim-matchup",
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- "nvim-treesitter/playground",
        "wellle/context.vim",
        "windwp/nvim-ts-autotag",
    },
    build = function()
        local ts_update = require("nvim-treesitter.install").update { with_sync = true }
        ts_update()
    end,
    init = function()
        vim.g.context_enabled = 0
        vim.g.context_add_mappings = 0
        vim.g.context_highlight_normal = "NormalFloat"
        vim.g.context_highlight_border = "<hide>"
        vim.g.matchup_transmute_enabled = 1
        vim.g.matchup_matchparen_offscreen = {}
    end,
    config = function()
        require("nvim-treesitter.configs").setup { ---@diagnostic disable-line: missing-fields
            highlight = {
                enable = not vim.g.vscode,
            },
            auto_install = true,
            autotag = {
                enable = not vim.g.vscode,
            },
            matchup = {
                enable = not vim.g.vscode,
            },
            -- playground = {
            --     enable = not vim.g.vscode,
            --     disable = {},
            --     updatetime = 25,
            --     persist_queries = false,
            --     keybindings = {
            --         toggle_query_editor = "o",
            --         toggle_hl_groups = "i",
            --         toggle_injected_languages = "t",
            --         toggle_anonymous_nodes = "a",
            --         toggle_language_display = "I",
            --         focus_language = "f",
            --         unfocus_language = "F",
            --         update = "R",
            --         goto_node = "<cr>",
            --         show_help = "?",
            --     },
            -- },
            -- query_linter = {
            --     enable = true,
            --     use_virtual_text = true,
            --     lint_events = { "BufWrite", "CursorHold" },
            -- },
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
            require("treesitter-context").setup {
                trim_scope = "inner",
            }

            vim.api.nvim_create_autocmd("BufWinEnter", {
                group = vim.api.nvim_create_augroup("ToggleContext", { clear = true }),
                callback = function()
                    if
                        vim.bo.buftype ~= ""
                        or require("nvim-treesitter.parsers").has_parser(
                            require("nvim-treesitter.parsers").get_buf_lang()
                        )
                    then
                        vim.cmd.ContextDisableWindow()
                    else
                        vim.cmd.ContextEnableWindow()
                    end
                end,
            })

            require("rainbow-delimiters.setup").setup { blacklist = { "comment" } }

            -- vim.keymap.set( "n", "<leader>tk", "<cmd>TSHighlightCapturesUnderCursor<cr>", { desc = "View treesitter highlights" })
            -- vim.keymap.set("n", "<leader>tn", "<cmd>TSNodeUnderCursor<cr>", { desc = "View treesitter node" })
            -- vim.keymap.set("n", "<leader>tp", "<cmd>TSPlaygroundToggle<cr>", { desc = "Toggle treesitter playground" })
        end
    end,
}
