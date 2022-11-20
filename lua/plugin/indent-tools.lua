return {
    "JulesNP/indent-tools.nvim",
    branch = "extend-nav",
    requires = "arsham/arshlib.nvim",
    config = function()
        require("indent-tools").config {}
    end,
}
