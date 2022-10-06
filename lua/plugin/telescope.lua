return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
        require("telescope").setup {
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {},
                },
            },
        }
        require("telescope").load_extension "ui-select"

        local builtin = require "telescope.builtin"
        require("which-key").register {
            ["<leader>f"] = {
                name = "find",
                b = { builtin.buffers, "Find buffer" },
                d = { builtin.diagnostics, "Find diagnostic" },
                f = { builtin.find_files, "Find file" },
                g = { builtin.live_grep, "Find with grep" },
                h = { builtin.help_tags, "Find help tag" },
                o = { builtin.oldfiles, "Find recent file" },
                r = { builtin.resume, "Resume find" },
                s = { builtin.lsp_dynamic_workspace_symbols, "Find workspace symbol" },
                w = { builtin.grep_string, "Find word under cursor" },
            },
        }
    end,
}
