return {
    "gbprod/substitute.nvim",
    keys = {
        {
            "s",
            function()
                require("substitute").operator()
            end,
            desc = "Substitute text",
        },
        {
            "ss",
            function()
                require("substitute").line()
            end,
            desc = "Substitute line",
        },
        {
            "S",
            function()
                require("substitute").eol()
            end,
            desc = "Substitute to end of line",
        },
        {
            "sx",
            function()
                require("substitute.exchange").operator()
            end,
            desc = "Exchange text",
        },
        {
            "sxx",
            function()
                require("substitute.exchange").line()
            end,
            desc = "Exchange lines",
        },
        {
            "sxc",
            function()
                require("substitute.exchange").cancel()
            end,
            desc = "Cancel exchange",
        },
        {
            "s",
            function()
                require("substitute").visual()
            end,
            desc = "Substitute selection",
            mode = "x",
        },
        {
            "X",
            function()
                require("substitute.exchange").visual()
            end,
            desc = "Exchange selection",
            mode = "x",
        },
    },
    opts = {
        highlight_substituted_text = {
            timer = 300,
        },
    },
}
