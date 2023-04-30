local function toggle()
    -- Determine whether to use vertical or horizontal terminal split
    -- based on width of largest window in the current tab
    local max_width, max_height = 0, 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local width, height = vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win)
        if width * height > max_width * max_height then
            max_width = width
            max_height = height
        end
    end
    if max_width >= 160 then
        local width = max_width / math.floor(max_width / 80)
        require("toggleterm").toggle(vim.v.count, width, nil, "vertical")
    else
        local height = math.max(math.min(15, max_height / 2), max_height / 4)
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
        {
            "<c-\\>",
            function()
                local cmd = vim.api.nvim_replace_termcodes(
                    ":ToggleTermSendVisualSelection " .. vim.v.count .. "<cr>",
                    true,
                    true,
                    true
                )
                vim.api.nvim_feedkeys(cmd, "m", true)
            end,
            desc = "Send selection to ToggleTerm",
            mode = "x",
        },
    },
    opts = {
        autochdir = true,
    },
}
