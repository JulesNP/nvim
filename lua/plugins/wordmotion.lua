return {
    "chaoren/vim-wordmotion",
    event = { "BufRead", "CmdlineEnter", "InsertEnter" },
    init = function()
        vim.g.wordmotion_mappings = {
            w = "<m-w>",
            b = "<m-b>",
            e = "<m-e>",
            ge = "g<m-e>",
            aw = "a<m-w>",
            iw = "i<m-w>",
            ["<C-R><C-W>"] = "<c-r><m-w>",
            W = "",
            B = "",
            E = "",
            gE = "",
            aW = "",
            iW = "",
            ["<C-R><C-A>"] = "",
        }
        vim.keymap.set({ "n", "o", "x" }, "<d-w>", "<plug>Wordmotion_w")
        vim.keymap.set({ "n", "o", "x" }, "<d-b>", "<plug>Wordmotion_b")
        vim.keymap.set({ "n", "o", "x" }, "<d-e>", "<plug>Wordmotion_e")
        vim.keymap.set({ "n", "o", "x" }, "<d-ge>", "<plug>Wordmotion_ge")
        vim.keymap.set({ "o", "x" }, "a<d-w>", "<plug>Wordmotion_aw")
        vim.keymap.set({ "o", "x" }, "i<d-w>", "<plug>Wordmotion_iw")
        vim.keymap.set("c", "<c-r><d-w>", "<plug>Wordmotion_<C-R><C-W>")
    end,
}
