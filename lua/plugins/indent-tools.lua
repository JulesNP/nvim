return {
    "arsham/indent-tools.nvim",
    event = "BufRead",
    ft = "markdown",
    dependencies = "arsham/arshlib.nvim",
    config = function()
        require("indent-tools").config {}
    end,
}
