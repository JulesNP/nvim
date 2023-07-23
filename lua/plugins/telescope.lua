return {
    "nvim-telescope/telescope.nvim",
    cond = not vim.g.vscode,
    branch = "0.1.x",
    dependencies = {
        "debugloop/telescope-undo.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    ft = { "mason" },
    keys = vim.g.vscode and {} or {
        {
            "<leader>'",
            function()
                require("telescope.builtin").marks()
            end,
            desc = "Find mark",
        },
        {
            "<leader>/",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "Find with live grep",
        },
        {
            "<leader>6",
            function()
                require "enhanced-find"()
            end,
            desc = "Find recent files in cwd",
        },
        {
            "<leader>8",
            function()
                require("telescope.builtin").grep_string()
            end,
            desc = "Find word under cursor",
        },
        {
            "<leader><c-o>",
            function()
                require("telescope.builtin").jumplist()
            end,
            desc = "Find in jumplist",
        },
        {
            "<leader><leader>",
            function()
                require "enhanced-find"()
            end,
            desc = "Find recent files in cwd",
        },
        {
            "<leader>fb",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "Find buffer",
        },
        {
            "<leader>fd",
            function()
                require("telescope.builtin").diagnostics()
            end,
            desc = "Find diagnostic",
        },
        {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files()
            end,
            desc = "Find files",
        },
        {
            "<leader>fg",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "Find with live grep",
        },
        {
            "<leader>fh",
            function()
                require("telescope.builtin").help_tags()
            end,
            desc = "Find help tag",
        },
        {
            "<leader>fj",
            function()
                require("telescope.builtin").jumplist()
            end,
            desc = "Find in jumplist",
        },
        {
            "<leader>fld",
            function()
                require("telescope.builtin").lsp_definitions()
            end,
            desc = "Find definitions",
        },
        {
            "<leader>fli",
            function()
                require("telescope.builtin").lsp_incoming_calls()
            end,
            desc = "Find incoming calls",
        },
        {
            "<leader>flm",
            function()
                require("telescope.builtin").lsp_implementations()
            end,
            desc = "Find implementations",
        },
        {
            "<leader>flo",
            function()
                require("telescope.builtin").lsp_outgoing_calls()
            end,
            desc = "Find outgoing calls",
        },
        {
            "<leader>flr",
            function()
                require("telescope.builtin").lsp_references()
            end,
            desc = "Find references",
        },
        {
            "<leader>fls",
            function()
                require("telescope.builtin").lsp_document_symbols()
            end,
            desc = "Find document symbols",
        },
        {
            "<leader>flt",
            function()
                require("telescope.builtin").lsp_type_definitions()
            end,
            desc = "Find type definitions",
        },
        {
            "<leader>flw",
            function()
                require("telescope.builtin").lsp_workspace_symbols()
            end,
            desc = "Find workspace symbols",
        },
        {
            "<leader>fly",
            function()
                require("telescope.builtin").lsp_dynamic_workspace_symbols()
            end,
            desc = "Find dynamic workspace symbols",
        },
        {
            "<leader>fo",
            function()
                require("telescope.builtin").oldfiles()
            end,
            desc = "Find recent file",
        },
        {
            "<leader>fp",
            function()
                require("telescope.builtin").builtin()
            end,
            desc = "Find builtin picker",
        },
        {
            "<leader>fq",
            function()
                require("telescope.builtin").quickfix()
            end,
            desc = "Find in quickfix list",
        },
        {
            "<leader>fr",
            function()
                require("telescope.builtin").resume()
            end,
            desc = "Resume find",
        },
        {
            "<leader>fs",
            function()
                require("telescope.builtin").lsp_dynamic_workspace_symbols()
            end,
            desc = "Find workspace symbol",
        },
        {
            "<leader>ft",
            function()
                require("telescope.builtin").colorscheme()
            end,
            desc = "Find theme",
        },
        { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Search undo tree" },
        {
            "<leader>fw",
            function()
                require("telescope.builtin").grep_string()
            end,
            desc = "Find word under cursor",
        },
        {
            "<leader>fz",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "Fuzzy find in current buffer",
        },
        {
            "<leader>gfB",
            function()
                require("telescope.builtin").git_branches()
            end,
            desc = "Find git branch",
        },
        {
            "<leader>gfb",
            function()
                require("telescope.builtin").git_bcommits()
            end,
            desc = "Find git buffer commits",
        },
        {
            "<leader>gfc",
            function()
                require("telescope.builtin").git_commits()
            end,
            desc = "Find git commits",
        },
        {
            "<leader>gff",
            function()
                require("telescope.builtin").git_files()
            end,
            desc = "Find git files",
        },
        {
            "<leader>gfs",
            function()
                require("telescope.builtin").git_status()
            end,
            desc = "Find git status",
        },
        {
            "<leader>gfz",
            function()
                require("telescope.builtin").git_stash()
            end,
            desc = "Find git stash",
        },
        {
            "<leader>scd",
            "<cmd>SessionManager load_current_dir_session<cr>",
            desc = "Load session from current directory",
        },
        { "<leader>sd", "<cmd>SessionManager delete_session<cr>", desc = "Delete session" },
        { "<leader>ss", "<cmd>SessionManager load_session<cr>", desc = "Select session" },
        { "<leader>sw", "<cmd>SessionManager save_current_session<cr>", desc = "Save current session" },
        { "<leader>u", "<cmd>Telescope undo<cr>", desc = "Search undo tree" },
    },
    config = function()
        local telescope = require "telescope"
        local actions = require "telescope.actions"
        local tu_actions = require "telescope-undo.actions"
        telescope.setup {
            defaults = {
                borderchars = { " " },
                mappings = {
                    i = {
                        ["<a-s>"] = actions.toggle_all,
                        ["<c-d>"] = actions.results_scrolling_down,
                        ["<c-j>"] = actions.preview_scrolling_down,
                        ["<c-k>"] = actions.preview_scrolling_up,
                        ["<c-s>"] = actions.select_horizontal,
                        ["<c-u>"] = actions.results_scrolling_up,
                    },
                    n = {
                        ["<a-s>"] = actions.toggle_all,
                        ["<c-c>"] = actions.close,
                        ["<c-d>"] = actions.results_scrolling_down,
                        ["<c-j>"] = actions.preview_scrolling_down,
                        ["<c-k>"] = actions.preview_scrolling_up,
                        ["<c-n>"] = actions.move_selection_next,
                        ["<c-p>"] = actions.move_selection_previous,
                        ["<c-s>"] = actions.select_horizontal,
                        ["<c-u>"] = actions.results_scrolling_up,
                        q = actions.close,
                        s = actions.toggle_selection,
                    },
                },
            },
            pickers = {
                buffers = {
                    mappings = {
                        i = {
                            ["<c-x>"] = actions.delete_buffer,
                        },
                        n = {
                            ["<c-x>"] = actions.delete_buffer,
                            x = actions.delete_buffer,
                        },
                    },
                },
                include_current_line = true,
                trim_text = true,
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown { borderchars = { " " } },
                },
                undo = {
                    diff_context_lines = 5,
                    mappings = {
                        i = {
                            ["<c-y>"] = tu_actions.yank_additions,
                            ["<a-y>"] = tu_actions.yank_deletions,
                            ["<cr>"] = tu_actions.restore,
                        },
                    },
                },
            },
        }
        telescope.load_extension "ui-select"
        telescope.load_extension "undo"
    end,
}
