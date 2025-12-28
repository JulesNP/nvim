return {
    "Exafunction/windsurf.vim",
    cond = not vim.g.vscode,
    keys = vim.g.vscode and {} or {
        {
            "<leader>tc",
            [[<cmd>Codeium Toggle<cr><cmd>echo "Codeium:" codeium#GetStatusString()<cr>]],
            desc = "Toggle Codeium completion",
        },
    },
    init = function()
        vim.g.codeium_enabled = false
        vim.g.codeium_disable_bindings = 1
    end,
    config = function()
        local function accept()
            return "<c-g>u" .. vim.fn["codeium#Accept"]()
        end
        local function cycle_next()
            return vim.fn["codeium#CycleCompletions"](1)
        end
        local function cycle_prev()
            return vim.fn["codeium#CycleCompletions"](-1)
        end
        local function clear()
            return vim.fn["codeium#Clear"]()
        end

        vim.keymap.set("i", "<c-bslash>", accept, { expr = true, silent = true })
        vim.keymap.set("i", "<c-]>", cycle_next, { expr = true, silent = true })
        vim.keymap.set("i", "<c-bs>", clear, { expr = true, silent = true })

        vim.keymap.set("i", "<m-bslash>", accept, { expr = true, silent = true })
        vim.keymap.set("i", "<m-]>", cycle_next, { expr = true, silent = true })
        vim.keymap.set("i", "<m-[>", cycle_prev, { expr = true, silent = true })
        vim.keymap.set("i", "<m-bs>", clear, { expr = true, silent = true })

        vim.keymap.set("i", "<d-bslash>", accept, { expr = true, silent = true })
        vim.keymap.set("i", "<d-]>", cycle_next, { expr = true, silent = true })
        vim.keymap.set("i", "<d-[>", cycle_prev, { expr = true, silent = true })
        vim.keymap.set("i", "<d-bs>", clear, { expr = true, silent = true })
    end,
}
