return {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "v0.6",
    opts = {
        { "[|", "|]", fly = true, dosuround = true, newline = true, space = true },
        { "(|", "|)", fly = true, dosuround = true, newline = true, space = true, disable_end = true },
        { "{|", "|}", fly = true, dosuround = true, newline = true, space = true },
        { ">", "<", newline = true, disable_start = true, disable_end = true },
        {
            "'",
            "'",
            suround = true,
            cond = function(fn)
                return not fn.in_lisp() or fn.in_string()
            end,
            alpha = true,
            nft = { "tex", "fsharp" },
            multiline = false,
        },
        {
            "`",
            "`",
            cond = function(fn)
                return not fn.in_lisp() or fn.in_string()
            end,
            nft = { "tex", "fsharp" },
            multiline = false,
        },
        { "```", "```", newline = true },
        { '"""', '"""', newline = true },
        { "'''", "'''", newline = true },
    },
}
