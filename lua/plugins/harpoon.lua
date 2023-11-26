return {
    "ThePrimeagen/harpoon",
    cond = not vim.g.vscode,
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
    ft = "text",
    keys = vim.g.vscode and {} or {
        {
            "<leader><leader>",
            function()
                if require("harpoon.mark").get_length() > 1 then
                    require("harpoon.ui").toggle_quick_menu()
                else
                    vim.cmd "Pick files"
                end
            end,
            desc = "Harpoon file menu",
        },
        {
            "[[",
            function()
                require("harpoon.ui").nav_next()
            end,
            desc = "Go to next Harpoon file",
        },
        {
            "]]",
            function()
                require("harpoon.ui").nav_prev()
            end,
            desc = "Go to previous Harpoon file",
        },
        {
            "<leader>`",
            function()
                require("harpoon.ui").toggle_quick_menu()
            end,
            desc = "Harpoon file menu",
        },
        {
            "<leader>m",
            function()
                require("harpoon.mark").add_file()
            end,
            desc = "Mark file",
        },
        {
            "<leader>1",
            function()
                require("harpoon.ui").nav_file(1)
            end,
            desc = "Go to Harpoon file 1",
        },
        {
            "<leader>2",
            function()
                require("harpoon.ui").nav_file(2)
            end,
            desc = "Go to Harpoon file 2",
        },
        {
            "<leader>3",
            function()
                require("harpoon.ui").nav_file(3)
            end,
            desc = "Go to Harpoon file 3",
        },
        {
            "<leader>4",
            function()
                require("harpoon.ui").nav_file(4)
            end,
            desc = "Go to Harpoon file 4",
        },
        {
            "<leader>5",
            function()
                require("harpoon.ui").nav_file(5)
            end,
            desc = "Go to Harpoon file 5",
        },
        {
            "<leader>6",
            function()
                require("harpoon.ui").nav_file(6)
            end,
            desc = "Go to Harpoon file 6",
        },
        {
            "<leader>7",
            function()
                require("harpoon.ui").nav_file(7)
            end,
            desc = "Go to Harpoon file 7",
        },
        {
            "<leader>8",
            function()
                require("harpoon.ui").nav_file(8)
            end,
            desc = "Go to Harpoon file 8",
        },
        {
            "<leader>9",
            function()
                require("harpoon.ui").nav_file(9)
            end,
            desc = "Go to Harpoon file 9",
        },
        {
            "<leader>0",
            function()
                require("harpoon.ui").nav_file(10)
            end,
            desc = "Go to Harpoon file 10",
        },
    },
    config = function()
        require("harpoon").setup {}
    end,
}
