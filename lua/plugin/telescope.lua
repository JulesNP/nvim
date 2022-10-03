return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = function()
        local builtin = require "telescope.builtin"
        require("which-key").register {
            ["<leader>f"] = {
                name = "find",
                b = { builtin.buffers, "Find buffer" },
                f = { builtin.find_files, "Find file" },
                g = { builtin.live_grep, "Find with grep" },
                h = { builtin.help_tags, "Find help tag" },
                o = { builtin.oldfiles, "Find recent file" },
                r = { builtin.resume, "Resume find" },
            },
        }
    end,
}
