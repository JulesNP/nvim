return {
    "arsham/indent-tools.nvim",
    requires = "arsham/arshlib.nvim",
    config = function()
        require("indent-tools").config {}
    end,
}
