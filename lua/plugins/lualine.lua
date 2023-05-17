return {
    "nvim-lualine/lualine.nvim",
    cond = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
    opts = {
        options = {
            disabled_filetypes = { "neo-tree" },
            section_separators = "",
            component_separators = "",
        },
        sections = {
            lualine_b = { "branch", { "diff", padding = { left = 0, right = 1 } } },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = {
                { "diagnostics", padding = { left = 1, right = 0 } },
                {
                    "encoding",
                    cond = function()
                        return vim.bo.fileencoding ~= "utf-8"
                    end,
                    padding = { left = 1, right = 0 },
                },
                {
                    "fileformat",
                    cond = function()
                        return vim.bo.fileformat ~= "unix"
                    end,
                    padding = { left = 1, right = 0 },
                },
                "filetype",
            },
        },
        inactive_sections = {
            lualine_c = { { "filename", path = 1 } },
            lualine_x = { "progress", "location" },
        },
        extensions = {
            "fugitive",
            "man",
            "quickfix",
            "toggleterm",
        },
    },
}
