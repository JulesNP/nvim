vim.keymap.set("n", "<a-down>", "<c-w>+", { desc = "Increase height" })
vim.keymap.set("n", "<a-left>", "<c-w><lt>", { desc = "Decrease width" })
vim.keymap.set("n", "<a-right>", "<c-w>>", { desc = "Increase width" })
vim.keymap.set("n", "<a-up>", "<c-w>-", { desc = "Decrease height" })
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Go to the left window" })
vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Go to the down window" })
vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Go to the up window" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Go to the right window" })
vim.keymap.set("n", "<c-q>", "<c-w>q", { desc = "Quit a window" })
vim.keymap.set("n", "<d-a>", "ga", { desc = "Show ASCII value" })
vim.keymap.set("n", "<d-s>", "<cmd>wall<bar>mkview<cr>", { desc = "Save all modified buffers" })
vim.keymap.set("n", "<leader>X", "<cmd>bdelete<cr>", { desc = "Close window and buffer" })
vim.keymap.set("n", "<leader>gf", "<cmd>e <cfile><cr>", { desc = "Create file under cursor" })
vim.keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Open Lazy.nvim" })
vim.keymap.set("n", "<leader>n", "<cmd>enew<bar>set filetype=text<cr>", { desc = "New buffer" })
vim.keymap.set("n", "<leader>tl", "<cmd>set number! relativenumber!<cr>", { desc = "Toggle line numbers" })
vim.keymap.set("n", "<leader>ts", "<cmd>windo set scrollbind! cursorbind!<cr>", { desc = "Toggle scroll/cursor sync" })
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap" })
vim.keymap.set("n", "<m-a>", "ga", { desc = "Show ASCII value" })
vim.keymap.set("n", "<m-s>", "<cmd>wall<bar>mkview<cr>", { desc = "Save all modified buffers" })
vim.keymap.set("n", "gB", "<cmd>bprevious<cr>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "gb", "<cmd>bnext<cr>", { desc = "Go to next buffer" })

vim.keymap.set({ "i", "n", "x" }, "<c-s>", "<cmd>update<bar>mkview<cr><esc>", { desc = "Save if modified" })

vim.keymap.set("t", "<c-h>", "<cmd>wincmd h<cr>", { desc = "Go to the left window" })
vim.keymap.set("t", "<c-j>", "<cmd>wincmd j<cr>", { desc = "Go to the down window" })
vim.keymap.set("t", "<c-k>", "<cmd>wincmd k<cr>", { desc = "Go to the up window" })
vim.keymap.set("t", "<c-l>", "<cmd>wincmd l<cr>", { desc = "Go to the right window" })
vim.keymap.set("t", "<d-v>", [[<c-\><c-n>"+pa]], { desc = "Paste from clipboard" })
vim.keymap.set("t", "<c-s-v>", [[<c-\><c-n>"+pa]], { desc = "Paste from clipboard" })
vim.keymap.set("t", "<d-x>", [[<c-\><c-n>]], { desc = "Go to Normal mode" })
vim.keymap.set("t", "<m-x>", [[<c-\><c-n>]], { desc = "Go to Normal mode" })

vim.keymap.set("x", "<", "<gv", { desc = "Shift left" })
vim.keymap.set("x", ">", ">gv", { desc = "Shift left" })
vim.keymap.set("x", "<leader>s", ":sort<cr>", { desc = "Sort selection" })
vim.keymap.set("x", "y", "ygv<esc>", { desc = "Yank selection" })
vim.keymap.set("x", "Y", "Ygv<esc>", { desc = "Yank selection linewise" })

local function putline(action)
    return function()
        local regType = vim.fn.getregtype(vim.v.register)
        if regType ~= "V" then
            local regValue = vim.fn.getreg(vim.v.register)
            vim.fn.setreg(vim.v.register, regValue, "V")
            vim.cmd('normal! "' .. vim.v.register .. vim.v.count .. action)
            vim.fn.setreg(vim.v.register, regValue, regType)
        else
            vim.cmd('normal! "' .. vim.v.register .. vim.v.count .. action)
        end
    end
end

vim.keymap.set("n", "]p", putline "]p", { desc = "Put text after cursor at current indent" })
vim.keymap.set("n", "]P", putline "]P", { desc = "Put text after cursor at current indent" })
vim.keymap.set("n", "[p", putline "[p", { desc = "Put text before cursor at current indent" })
vim.keymap.set("n", "[P", putline "[P", { desc = "Put text before cursor at current indent" })
vim.keymap.set("n", ">p", putline "]p>']", { desc = "Put text after cursor at higher indent" })
vim.keymap.set("n", ">P", putline "[p>']", { desc = "Put text before cursor at higher indent" })
vim.keymap.set("n", "<p", putline "]p<']", { desc = "Put text after cursor at lower indent" })
vim.keymap.set("n", "<P", putline "[p<']", { desc = "Put text before cursor at lower indent" })
vim.keymap.set("n", "=p", putline "]p=']", { desc = "Put text after cursor and reformat" })
vim.keymap.set("n", "=P", putline "[p=']", { desc = "Put text before cursor and reformat" })

vim.keymap.set("n", "] ", function()
    vim.cmd("normal! m`" .. vim.v.count .. "o``")
end, { desc = "Add blank line below" })
vim.keymap.set("n", "[ ", function()
    vim.cmd("normal! m`" .. vim.v.count .. "O``")
end, { desc = "Add blank line above" })

vim.keymap.set({ "n", "x" }, "j", function()
    vim.api.nvim_feedkeys(vim.v.count > 0 and "j" or "gj", "n", false)
end, { desc = "Down", expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
    if vim.v.count == 0 and vim.fn.reg_recording() == "" and vim.fn.winline() <= vim.o.scrolloff + 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-y>", true, false, true), "n", true)
        vim.api.nvim_input "gk"
    else
        vim.api.nvim_feedkeys(vim.v.count > 0 and "k" or "gk", "n", false)
    end
end, { desc = "Up", expr = true })

vim.keymap.set({ "n", "o", "x" }, "H", function()
    vim.o.scrolloff = require "context-height"()
    vim.api.nvim_feedkeys(vim.v.count > 0 and vim.v.count .. "H" or "H", "n", false)
end, { desc = "Home line of window (top)" })

vim.keymap.set({ "n", "o", "x" }, "L", function()
    vim.o.scrolloff = 0
    vim.api.nvim_feedkeys(vim.v.count > 0 and vim.v.count .. "L" or "L", "n", false)
end, { desc = "Last line of window" })
