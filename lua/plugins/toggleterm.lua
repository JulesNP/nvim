local function toggle()
    local columns = vim.o.columns
    if columns >= 160 then
        local width = vim.o.columns / math.floor(vim.o.columns / 80)
        require("toggleterm").toggle(vim.v.count, width, nil, "vertical")
    else
        local height = math.max(math.min(15, vim.o.lines / 2), vim.o.lines / 4)
        require("toggleterm").toggle(vim.v.count, height, nil, "horizontal")
    end
end

return {
    "akinsho/toggleterm.nvim",
    cond = not vim.g.vscode,
    version = "*",
    keys = vim.g.vscode and {} or {
        { "<c-\\>", toggle, desc = "Open ToggleTerm" },
        { "<c-\\>", toggle, desc = "Open ToggleTerm", mode = "t" },
    },
    opts = {},
}
