return {
    "nvim-telescope/telescope.nvim",
    cond = not vim.g.vscode,
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
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
            "<leader>fc",
            function()
                require("telescope.builtin").colorscheme()
            end,
            desc = "Find colorscheme",
        },
        {
            "<leader>fd",
            function()
                require("telescope.builtin").diagnostics()
            end,
            desc = "Find diagnostic",
        },
        { "<leader>ff", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
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
            "-",
            "<cmd>Telescope file_browser initial_mode=normal depth=1 path=%:p:h scroll_strategy=limit select_buffer=true sorting_strategy=ascending<cr>",
            desc = "Browse parent directory",
        },
        {
            "<leader>scd",
            "<cmd>SessionManager load_current_dir_session<cr>",
            desc = "Load session from current directory",
        },
        { "<leader>sd", "<cmd>SessionManager delete_session<cr>", desc = "Delete session" },
        { "<leader>ss", "<cmd>SessionManager load_session<cr>", desc = "Select session" },
        { "<leader>sw", "<cmd>SessionManager save_current_session<cr>", desc = "Save current session" },
    },
    config = function()
        local telescope = require "telescope"
        local actions = require "telescope.actions"
        local fb_actions = require("telescope").extensions.file_browser.actions
        telescope.setup {
            defaults = {
                borderchars = { " " },
                mappings = {
                    i = {
                        ["<a-s>"] = actions.toggle_all,
                        ["<c-s>"] = actions.select_horizontal,
                    },
                    n = {
                        ["<a-s>"] = actions.toggle_all,
                        ["<c-c>"] = actions.close,
                        ["<c-n>"] = actions.move_selection_next,
                        ["<c-p>"] = actions.move_selection_previous,
                        ["<c-s>"] = actions.select_horizontal,
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
            },
            extensions = {
                file_browser = {
                    depth = false,
                    grouped = true,
                    hide_parent_dir = true,
                    mappings = {
                        i = {
                            ["<a-h>"] = fb_actions.goto_parent_dir,
                            ["<a-s>"] = fb_actions.toggle_all,
                            ["<c-.>"] = fb_actions.change_cwd,
                        },
                        n = {
                            ["-"] = fb_actions.goto_parent_dir,
                            ["."] = fb_actions.change_cwd,
                            ["<a-s>"] = fb_actions.toggle_all,
                            ["<c-h>"] = fb_actions.toggle_hidden,
                            ["_"] = fb_actions.goto_cwd,
                            ["~"] = fb_actions.goto_home_dir,
                            h = fb_actions.goto_parent_dir,
                            l = actions.select_default,
                            t = false,
                        },
                    },
                },
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown { borderchars = { " " } },
                },
            },
        }
        telescope.load_extension "file_browser"
        telescope.load_extension "ui-select"
    end,
}