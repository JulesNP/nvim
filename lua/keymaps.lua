vim.keymap.set("n", "<a-left>", "<c-w><lt>", { desc = "Decrease width" })
vim.keymap.set("n", "<a-down>", "<c-w>+", { desc = "Increase height" })
vim.keymap.set("n", "<a-up>", "<c-w>-", { desc = "Decrease height" })
vim.keymap.set("n", "<a-right>", "<c-w>>", { desc = "Increase width" })
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Go to the left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Go to the down window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Go to the up window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Go to the right window" })
vim.keymap.set("n", "<c-q>", "<c-w>q", { desc = "Quit a window" })
vim.keymap.set("n", "<c-s>", "<cmd>update<bar>mkview<cr>", { desc = "Save if modified" })
vim.keymap.set("n", "<m-s>", "<cmd>wall<bar>mkview<cr>", { desc = "Save all modified buffers" })
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<bar>diffupdate<cr>", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>n", "<cmd>enew<bar>set filetype=markdown<cr>", { desc = "New buffer" })
vim.keymap.set("n", "<leader>X", "<cmd>bdelete<cr>", { desc = "Close window and buffer" })
vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Open Lazy.nvim" })
vim.keymap.set("n", "<m-a>", "ga", { desc = "Show ASCII value" })
vim.keymap.set("n", "gB", "<cmd>bprevious<cr>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "gb", "<cmd>bnext<cr>", { desc = "Go to next buffer" })
vim.keymap.set("n", "j", [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], { desc = "Down", expr = true })
vim.keymap.set("n", "k", [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], { desc = "Up", expr = true })
vim.keymap.set("n", "<leader>ts", "<cmd>windo set scrollbind! cursorbind!<cr>", { desc = "Toggle scroll/cursor sync" })
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap" })
vim.keymap.set("n", "<leader>tv", function()
    vim.o.virtualedit = vim.o.virtualedit == "" and "all" or ""
end, { desc = "Toggle virtual editing" })

vim.keymap.set("t", "<c-h>", "<cmd>wincmd h<cr>", { desc = "Go to the left window" })
vim.keymap.set("t", "<c-j>", "<cmd>wincmd j<cr>", { desc = "Go to the down window" })
vim.keymap.set("t", "<c-k>", "<cmd>wincmd k<cr>", { desc = "Go to the up window" })
vim.keymap.set("t", "<c-l>", "<cmd>wincmd l<cr>", { desc = "Go to the right window" })
vim.keymap.set("t", "<c-w>", [[<c-\><c-n>w]], { desc = "Input window command" })
vim.keymap.set("t", "<c-s-v>", [[<c-\><c-n>"+pa]], { desc = "Paste from clipboard" })
vim.keymap.set("t", "<m-x>", [[<c-\><c-n>]], { desc = "Go to Normal mode" })

vim.keymap.set("x", "<", "<gv", { desc = "Shift left" })
vim.keymap.set("x", ">", ">gv", { desc = "Shift left" })
vim.keymap.set("x", "<leader>s", ":sort<cr>", { desc = "Sort selection" })
vim.keymap.set("x", "j", [[v:count || mode(1)[0:1] == "no" ? "j" : "gj"]], { desc = "Down", expr = true })
vim.keymap.set("x", "k", [[v:count || mode(1)[0:1] == "no" ? "k" : "gk"]], { desc = "Up", expr = true })
vim.keymap.set("x", "y", "myy`y", { desc = "Yank selection" })
vim.keymap.set("x", "Y", "myY`y", { desc = "Yank selection linewise" })

vim.keymap.set({ "n", "o", "x" }, "H", function()
    local so = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative == "win" and config.zindex == 20 then
            so = config.height
        end
    end
    vim.o.scrolloff = so
    vim.api.nvim_feedkeys("H", "n", false)
end, { desc = "Home line of window (top)" })
vim.keymap.set({ "n", "o", "x" }, "L", function()
    vim.o.scrolloff = 0
    vim.api.nvim_feedkeys("L", "n", false)
end, { desc = "Last line of window" })
