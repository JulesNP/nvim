return {
    "anuvyklack/pretty-fold.nvim",
    config = function()
        require("pretty-fold").setup {
            fill_char = " ",
            process_comment_signs = "delete",
            sections = {
                left = { "content" },
                right = { " ", "number_of_folded_lines", ": ", "percentage", " " },
            },
        }
    end,
}
