return function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local config = vim.api.nvim_win_get_config(win)
        if config.zindex == 20 then
            return config.height
        end
    end
    return 0
end
