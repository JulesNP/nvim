return {
    {
        "folke/lazydev.nvim",
        cond = not vim.g.vscode,
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "saghen/blink.cmp",
        cond = not vim.g.vscode,
        event = { "CmdlineEnter", "InsertEnter" },
        dependencies = {
            "kristijanhusak/vim-dadbod-ui",
            "mikavilpas/blink-ripgrep.nvim",
            "moyiz/blink-emoji.nvim",
            "rafamadriz/friendly-snippets",
        },
        version = "*",
        opts = {
            keymap = {
                preset = "none",
                ["<c-d>"] = { "scroll_documentation_down", "fallback" },
                ["<c-e>"] = { "cancel", "fallback" },
                ["<c-n>"] = { "select_next", "fallback" },
                ["<c-p>"] = { "select_prev", "fallback" },
                ["<c-s>"] = { "show_signature", "hide_signature", "fallback" },
                ["<c-space>"] = { "show", "hide", "fallback" },
                ["<c-u>"] = { "scroll_documentation_up", "fallback" },
                ["<c-y>"] = { "select_and_accept", "fallback" },
                ["<cr>"] = { "accept", "fallback" },
                ["<down>"] = { "select_next", "fallback" },
                ["<s-tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<up>"] = { "select_prev", "fallback" },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            cmdline = {
                keymap = {
                    ["<c-space>"] = { "show", "hide", "fallback" },
                    ["<s-tab>"] = { "show_and_insert", "select_prev", "fallback" },
                    ["<tab>"] = { "show_and_insert", "select_next", "fallback" },
                },
                completion = {
                    menu = {
                        auto_show = function()
                            return vim.fn.getcmdtype() == ":"
                        end,
                    },
                    list = {
                        selection = {
                            preselect = false,
                        },
                    },
                },
            },
            completion = {
                menu = {
                    border = "none",
                    draw = {
                        treesitter = { "lsp" },
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind", gap = 1 } },
                    },
                },
                list = {
                    selection = {
                        preselect = false,
                    },
                },
                documentation = {
                    auto_show = true,
                },
                ghost_text = {
                    enabled = true,
                },
            },
            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    "dadbod",
                    "emoji",
                    "ripgrep",
                },
                per_filetype = {
                    lua = {
                        "lazydev",
                        "lsp",
                        "path",
                        "snippets",
                        "buffer",
                        "emoji",
                        "ripgrep",
                    },
                },
                providers = {
                    buffer = {
                        score_offset = -8,
                        opts = {
                            get_bufnrs = vim.api.nvim_list_bufs,
                        },
                    },
                    dadbod = {
                        name = "Dadbod",
                        module = "vim_dadbod_completion.blink",
                    },
                    emoji = {
                        module = "blink-emoji",
                        name = "Emoji",
                        score_offset = 16,
                    },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 128,
                    },
                    ripgrep = {
                        name = "Ripgrep",
                        module = "blink-ripgrep",
                        score_offset = -8,
                        opts = {
                            backend = {
                                project_root_fallback = false,
                                search_casing = "--smart-case",
                                additional_rg_options = { "--max-depth 4", "--one-file-system" },
                            },
                        },
                    },
                },
            },

            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
}
