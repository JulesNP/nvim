return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = {
        "folke/which-key.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
        require("telescope").setup {
            defaults = {
                mappings = {
                    i = {
                        ["<c-s>"] = require("telescope.actions").select_horizontal,
                        ["<c-x>"] = require("telescope.actions").delete_buffer,
                    },
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {},
                },
            },
        }
        require("telescope").load_extension "ui-select"

        local builtin = require "telescope.builtin"
        require("which-key").register {
            ["<leader>/"] = { builtin.live_grep, "Find with live grep" },
            ["<leader><c-o>"] = { builtin.jumplist, "Find in jumplist" },
            ["<leader>f"] = {
                name = "find",
                ["<space>"] = { builtin.builtin, "Find builtin picker" },
                b = { builtin.buffers, "Find buffer" },
                d = { builtin.diagnostics, "Find diagnostic" },
                f = { builtin.find_files, "Find file" },
                g = { builtin.live_grep, "Find with live grep" },
                h = { builtin.help_tags, "Find help tag" },
                j = { builtin.jumplist, "Find in jumplist" },
                o = { builtin.oldfiles, "Find recent file" },
                r = { builtin.resume, "Resume find" },
                s = { builtin.lsp_dynamic_workspace_symbols, "Find workspace symbol" },
                w = { builtin.grep_string, "Find word under cursor" },
            },
            ["<leader>g"] = {
                name = "git",
                f = {
                    name = "find",
                    B = { builtin.git_branches, "Find git branch" },
                    b = { builtin.git_bcommits, "Find git buffer commits" },
                    c = { builtin.git_commits, "Find git commits" },
                    f = { builtin.git_files, "Find git files" },
                    s = { builtin.git_status, "Find git status" },
                    z = { builtin.git_stash, "Find git stash" },
                },
            },
            ["<leader><leader>"] = {
                function()
                    builtin.oldfiles { only_cwd = true }
                end,
                "Find recent file in cwd",
            },
        }
    end,
}
