return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup {
            toggler = {
                block = "g//",
            },
            opleader = {
                block = "g/",
            },
        }
    end,
}
