local size, orientation = 80, "vertical"
local function toggle()
    -- Determine whether to use vertical or horizontal terminal split
    -- based on width of largest window in the current tab
    local max_width, max_height, toggleterm_visible = 0, 0, false
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local width, height = vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win)
        toggleterm_visible = toggleterm_visible or vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "toggleterm"
        if width * height > max_width * max_height then
            max_width = width
            max_height = height
        end
    end
    if not toggleterm_visible then
        if max_width >= 160 then
            size = max_width / math.floor(max_width / 80)
            orientation = "vertical"
        else
            size = math.max(math.min(15, max_height / 2), max_height / 4)
            orientation = "horizontal"
        end
    end
    require("toggleterm").toggle(vim.v.count, size, nil, orientation)
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
        {
            "<c-->",
            function()
                local Terminal = require("toggleterm.terminal").Terminal
                local localterm = Terminal:new {
                    hidden = true,
                    dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"),
                    direction = "float",
                    on_open = function(term)
                        vim.cmd "startinsert!"
                        vim.api.nvim_buf_set_keymap(
                            term.bufnr,
                            "t",
                            "<c-->",
                            "<cmd>close<cr>",
                            { noremap = true, silent = true }
                        )
                    end,
                }
                localterm:toggle()
            end,
            desc = "Open ToggleTerm",
        },
    },
    opts = {},
}
