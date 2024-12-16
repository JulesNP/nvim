return {
    "barklan/capslock.nvim",
    keys = {
        {
            "<leader>tl",
            "<plug>CapsLockToggle<cmd>=require('capslock').status_string()<cr>",
            mode = "n",
            desc = "Toggle soft caps lock",
        },
        {
            "<c-l>",
            "<plug>CapsLockToggle<cmd>=require('capslock').status_string()<cr>",
            mode = "i",
            desc = "Toggle soft caps lock",
        },
        {
            "<c-l>",
            "<plug>CapsLockToggle",
            mode = "c",
            desc = "Toggle soft caps lock",
        },
    },
    opts = {},
}
