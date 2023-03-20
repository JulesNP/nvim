return {
    "arsham/indent-tools.nvim",
    dependencies = "arsham/arshlib.nvim",
    config = function()
        require("indent-tools").config {}
    end,
}
