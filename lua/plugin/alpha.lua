return {
    "goolord/alpha-nvim",
    config = function()
        local dashboard = require "alpha.themes.dashboard"
        dashboard.section.header.val = {
            "             ▖     ",
            "┌─╮╭─╮╭─╮▖  ▖▖▄▄▗▄ ",
            "│ │├─┘│ │▝▖▞ ▌▌ ▌ ▌",
            "╵ ╵╰─╯╰─╯ ▝  ▘▘ ▘ ▘",
        }
        dashboard.section.buttons.val = {
            dashboard.button("<space> s s", "  Select session"),
            dashboard.button("<space> f o", "  Recently opened files"),
            dashboard.button("<space> f f", "  Find file"),
            dashboard.button("<space> b", "  New file"),
            dashboard.button("<space> w k", "  View keybindings"),
            dashboard.button("\\", "  Open file tree"),
            dashboard.button("q", "  Quit Neovim", "<cmd>qa<CR>"),
        }
        require("alpha").setup(dashboard.config)
    end,
}
