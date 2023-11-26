local function mini_ai_setup()
    local gen_ai_spec = require("mini.extra").gen_ai_spec
    local ts = require("mini.ai").gen_spec.treesitter
    require("mini.ai").setup {
        custom_textobjects = {
            F = ts { a = "@function.outer", i = "@function.inner" },
            I = gen_ai_spec.indent(),
            L = gen_ai_spec.line(),
            N = gen_ai_spec.number(),
            ["/"] = ts { a = "@comment.outer", i = "@comment.inner" },
            a = require("mini.ai").gen_spec.argument { separator = "[,;]" },
            d = gen_ai_spec.diagnostic(),
            g = gen_ai_spec.buffer(),
            o = ts { a = { "@conditional.outer", "@loop.outer" }, i = { "@conditional.inner", "@loop.inner" } },
        },
        n_lines = 100,
    }
end

local function mini_animate_setup()
    local animate = require "mini.animate"
    animate.setup {
        cursor = { timing = animate.gen_timing.linear { duration = 50, unit = "total" } },
        scroll = { timing = animate.gen_timing.linear { duration = 50, unit = "total" } },
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
    }
end

local function mini_clue_setup()
    local MiniClue = require "mini.clue"
    MiniClue.setup {
        triggers = {
            { mode = "c", keys = "<C-r>" },
            { mode = "i", keys = "<C-r>" },
            { mode = "i", keys = "<C-x>" },
            { mode = "n", keys = "'" },
            { mode = "n", keys = "<C-w>" },
            { mode = "n", keys = "<Leader>" },
            { mode = "n", keys = "[" },
            { mode = "n", keys = "]" },
            { mode = "n", keys = "`" },
            { mode = "n", keys = "g" },
            { mode = "n", keys = "z" },
            { mode = "n", keys = '"' },
            { mode = "x", keys = "'" },
            { mode = "x", keys = "<Leader>" },
            { mode = "x", keys = "`" },
            { mode = "x", keys = "g" },
            { mode = "x", keys = "z" },
            { mode = "x", keys = '"' },
        },

        clues = {
            MiniClue.gen_clues.builtin_completion(),
            MiniClue.gen_clues.g(),
            MiniClue.gen_clues.marks(),
            MiniClue.gen_clues.registers(),
            MiniClue.gen_clues.windows(),
            MiniClue.gen_clues.z(),
            { mode = "n", keys = "<leader>b", desc = "+debug" },
            { mode = "n", keys = "<leader>d", desc = "+diffview" },
            { mode = "n", keys = "<leader>e", desc = "+rest" },
            { mode = "n", keys = "<leader>f", desc = "+find" },
            { mode = "n", keys = "<leader>g", desc = "+git" },
            { mode = "n", keys = "<leader>h", desc = "+hunk" },
            { mode = "n", keys = "<leader>l", desc = "+lsp" },
            { mode = "n", keys = "<leader>o", desc = "+orgmode" },
            { mode = "n", keys = "<leader>r", desc = "+refactor" },
            { mode = "n", keys = "<leader>s", desc = "+session" },
            { mode = "n", keys = "<leader>t", desc = "+toggle" },
            { mode = "x", keys = "<leader>h", desc = "+hunk" },
            { mode = "x", keys = "<leader>r", desc = "+refactor" },
        },
    }
end

local function mini_files_setup()
    local MiniFiles = require "mini.files"
    local show_dotfiles = false

    local filter_show = function()
        return true
    end

    local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
    end

    local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh { content = { filter = new_filter } }
    end

    local files_set_cwd = function()
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        vim.fn.chdir(cur_directory)
    end

    local map_split = function(buf_id, lhs, direction)
        local rhs = function()
            local fs_entry = MiniFiles.get_fs_entry()
            local is_at_file = fs_entry ~= nil and fs_entry.fs_type == "file"

            if is_at_file then
                local new_target_window
                vim.api.nvim_win_call(MiniFiles.get_target_window() or 0, function()
                    vim.cmd(direction .. " split")
                    new_target_window = vim.api.nvim_get_current_win()
                end)
                MiniFiles.set_target_window(new_target_window)
            end

            MiniFiles.go_in()
        end

        local desc = "Split " .. direction
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
    end

    local yank_relative_path = function()
        local path = MiniFiles.get_fs_entry().path
        vim.fn.setreg('"', vim.fn.fnamemodify(path, ":."))
    end

    local minifiles_triggers = vim.api.nvim_create_augroup("MiniFilesMappings", { clear = true })

    vim.api.nvim_create_autocmd("User", {
        group = minifiles_triggers,
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
            local buf_id = args.data.buf_id
            map_split(buf_id, "gs", "horizontal")
            map_split(buf_id, "gv", "vertical")
            vim.keymap.set("n", "-", function()
                MiniFiles.go_out()
            end, { buffer = buf_id, desc = "Go out of directory" })
            vim.keymap.set("n", "<c-h>", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
            vim.keymap.set("n", "<c-j>", "<c-j>", { buffer = buf_id, desc = "Down" })
            vim.keymap.set("n", "<c-k>", "k", { buffer = buf_id, desc = "Up" })
            vim.keymap.set("n", "<c-l>", "<c-l>", { buffer = buf_id, desc = "Clear and redraw screen" })
            vim.keymap.set("n", "<c-q>", function()
                MiniFiles.close()
            end, { buffer = buf_id, desc = "Close" })
            vim.keymap.set("n", "<cr>", function()
                local fs_entry = MiniFiles.get_fs_entry()
                local is_at_file = fs_entry ~= nil and fs_entry.fs_type == "file"
                MiniFiles.go_in()
                if is_at_file then
                    MiniFiles.close()
                end
            end, { buffer = buf_id, desc = "Go in entry" })
            vim.keymap.set("n", "<esc>", function()
                MiniFiles.close()
            end, { buffer = buf_id, desc = "Close" })
            vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Toggle hidden files" })
            vim.keymap.set("n", "gh", "h", { buffer = buf_id, desc = "Left" })
            vim.keymap.set("n", "gl", "l", { buffer = buf_id, desc = "Right" })
            vim.keymap.set("n", "gy", yank_relative_path, { buffer = buf_id, desc = "Yank relative path" })
            vim.keymap.set("n", "g~", files_set_cwd, { buffer = buf_id, desc = "Set CWD" })
        end,
    })

    MiniFiles.setup {
        content = {
            filter = filter_hide,
        },
        mappings = {
            close = "q",
            go_in = "<tab>",
            go_in_plus = "l",
            go_out = "h",
            go_out_plus = "",
            reset = "<bs>",
            reveal_cwd = "@",
            show_help = "g?",
            synchronize = "<c-s>",
            trim_left = "<",
            trim_right = ">",
        },
        windows = {
            preview = true,
            width_focus = 40,
            width_preview = 30,
        },
    }
end

local function mini_pick_setup()
    local MiniPick = require "mini.pick"
    MiniPick.setup {
        mappings = {
            mark = "<c-space>",
            mark_and_move_down = {
                char = "<tab>",
                func = function()
                    local mappings = MiniPick.get_picker_opts().mappings
                    vim.api.nvim_input(mappings.mark .. mappings.move_down)
                end,
            },
            mark_and_move_up = {
                char = "<s-tab>",
                func = function()
                    local mappings = MiniPick.get_picker_opts().mappings
                    vim.api.nvim_input(mappings.mark .. mappings.move_up)
                end,
            },
            move_down_alt = {
                char = "<c-j>",
                func = function()
                    local mappings = MiniPick.get_picker_opts().mappings
                    vim.api.nvim_input(mappings.move_down)
                end,
            },
            refine = "<c-e>",
            toggle_info = "<c-/>",
            toggle_preview = "<c-k>",
            quickfix = {
                char = "<c-q>",
                func = function()
                    local items = MiniPick.get_picker_matches()
                    if items == nil then
                        return
                    end
                    if #items.marked > 0 then
                        MiniPick.default_choose_marked(items.marked)
                    else
                        MiniPick.default_choose_marked(items.all)
                    end
                    MiniPick.stop()
                end,
            },
        },
    }
    vim.ui.select = MiniPick.ui_select
end

local function mini_surround_setup()
    require("mini.surround").setup {
        mappings = {
            add = "ys",
            delete = "ds",
            find = "",
            find_left = "",
            highlight = "",
            replace = "cs",
            update_n_lines = "",
        },
        n_lines = 50,
        search_method = "cover_or_next",
    }
    vim.keymap.del("x", "ys")
    vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
    vim.keymap.set("n", "yss", "ys_", { remap = true })
end

return {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    keys = vim.g.vscode and {} or {
        {
            "\\",
            function()
                local MiniFiles = require "mini.files"
                if not MiniFiles.close() then
                    MiniFiles.open()
                end
            end,
            desc = "Open file browser",
        },
        {
            "-",
            function()
                local MiniFiles = require "mini.files"
                MiniFiles.open(vim.api.nvim_buf_get_name(0))
                MiniFiles.reveal_cwd()
            end,
            desc = "Open file browser",
        },
        {
            "<leader>f<leader>",
            "<cmd>Pick resume<cr>",
            desc = "Resume last search",
        },
        {
            "<leader>fb",
            function()
                local MiniPick = require "mini.pick"
                MiniPick.builtin.buffers(nil, {
                    mappings = {
                        wipeout = {
                            char = "<c-x>",
                            func = function()
                                local matches = MiniPick.get_picker_matches()
                                local items = MiniPick.get_picker_items()
                                if matches == nil or items == nil then
                                    return
                                end

                                local removals = matches.marked
                                local removal_inds = matches.marked_inds

                                if #removals == 0 then
                                    removals = { matches.current }
                                    removal_inds = { matches.current_ind }
                                end

                                for index, item in ipairs(removals) do
                                    vim.api.nvim_buf_delete(item.bufnr, {})
                                    table.remove(items, removal_inds[index])
                                end

                                MiniPick.set_picker_items(items)
                            end,
                        },
                    },
                })
            end,
            desc = "Find buffers",
        },
        {
            "<leader>fC",
            "<cmd>Pick list scope='change'<cr>",
            desc = "Find in changelist",
        },
        {
            "<leader>:",
            "<cmd>Pick commands<cr>",
            desc = "Find commands",
        },
        {
            "<leader>fe",
            "<cmd>Pick explorer<cr>",
            desc = "Find via file explorer",
        },
        {
            "<leader>fD",
            "<cmd>Pick lsp scope='declaration'<cr>",
            desc = "Find LSP declaration",
        },
        {
            "<leader>fd",
            "<cmd>Pick lsp scope='definition'<cr>",
            desc = "Find LSP definition",
        },
        {
            "<leader>ff",
            "<cmd>Pick files<cr>",
            desc = "Find files",
        },
        {
            "<leader>gb",
            "<cmd>Pick git_branches<cr>",
            desc = "Find branches",
        },
        {
            "<leader>gC",
            "<cmd>Pick git_commits<cr>",
            desc = "Find commits",
        },
        {
            "<leader>gd",
            "<cmd>Pick git_files scope='deleted'<cr>",
            desc = "Find deleted files",
        },
        {
            "<leader>gf",
            "<cmd>Pick git_files<cr>",
            desc = "Find tracked files",
        },
        {
            "<leader>gh",
            "<cmd>Pick git_hunks<cr>",
            desc = "Find hunks",
        },
        {
            "<leader>gi",
            "<cmd>Pick git_files scope='ignored'<cr>",
            desc = "Find ignored files",
        },
        {
            "<leader>gm",
            "<cmd>Pick git_files scope='modified'<cr>",
            desc = "Find modified files",
        },
        {
            "<leader>gu",
            "<cmd>Pick git_files scope='untracked'<cr>",
            desc = "Find untracked files",
        },
        {
            "<leader>fG",
            "<cmd>Pick grep<cr>",
            desc = "Find with grep",
        },
        {
            "<leader>fg",
            "<cmd>Pick grep_live<cr>",
            desc = "Find with live grep",
        },
        {
            "<leader>fH",
            "<cmd>Pick hl_groups<cr>",
            desc = "Find highlight groups",
        },
        {
            "<leader>fh",
            "<cmd>Pick help<cr>",
            desc = "Find help documents",
        },
        {
            "<leader>fi",
            "<cmd>Pick diagnostic<cr>",
            desc = "Find diagnostics",
        },
        {
            "<leader>fj",
            "<cmd>Pick list scope='jump'<cr>",
            desc = "Find in jumplist",
        },
        {
            "<leader>fk",
            "<cmd>Pick keymaps<cr>",
            desc = "Find keymaps",
        },
        {
            "<leader>fl",
            "<cmd>Pick buf_lines<cr>",
            desc = "Find buffer lines",
        },
        {
            "<leader>fM",
            "<cmd>Pick marks<cr>",
            desc = "Find marks",
        },
        {
            "<leader>fo",
            "<cmd>Pick options<cr>",
            desc = "Find Neovim options",
        },
        {
            "<leader>fo",
            "<cmd>Pick oldfiles<cr>",
            desc = "Find oldfiles",
        },
        {
            "<leader>fR",
            "<cmd>Pick registers<cr>",
            desc = "Find registers",
        },
        {
            "<leader>fr",
            "<cmd>Pick lsp scope='references'<cr>",
            desc = "Find LSP references",
        },
        {
            "<leader>fS",
            "<cmd>Pick lsp scope='workspace_symbol'<cr>",
            desc = "Find LSP workspace symbol",
        },
        {
            "<leader>fs",
            "<cmd>Pick lsp scope='document_symbol'<cr>",
            desc = "Find LSP document symbol",
        },
        {
            "<leader>fT",
            "<cmd>Pick treesitter<cr>",
            desc = "Find treesitter nodes",
        },
        {
            "<leader>ft",
            "<cmd>Pick lsp scope='type_definition'<cr>",
            desc = "Find LSP type definition",
        },
        {
            "<leader>fq",
            "<cmd>Pick list scope='quickfix'<cr>",
            desc = "Find in quickfix list",
        },
        {
            "<leader>fw",
            "<cmd>Pick grep pattern='<cword>'<cr>",
            desc = "Find current word",
        },
        {
            "<leader>fz",
            "<cmd>Pick spellsuggest<cr>",
            desc = "Find spelling suggestions",
        },
        {
            "<leader>scd",
            "<cmd>SessionManager load_current_dir_session<cr>",
            desc = "Load session from current directory",
        },
        { "<leader>sd", "<cmd>SessionManager delete_session<cr>", desc = "Delete session" },
        { "<leader>ss", "<cmd>SessionManager load_session<cr>", desc = "Select session" },
        { "<leader>sw", "<cmd>SessionManager save_current_session<cr>", desc = "Save current session" },
    },
    init = function()
        -- Disable mini.indentscope in certain filetypes
        if vim.g.vscode then
            vim.g.miniindentscope_disable = true
        else
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("IndentScopeDisable", { clear = true }),
                callback = function()
                    if
                        vim.bo.buftype ~= ""
                        or vim.bo.filetype == "toggleterm"
                        or vim.bo.filetype == "dbout"
                        or vim.bo.filetype == "dbui"
                    then
                        vim.b.miniindentscope_disable = true
                    end
                end,
            })
        end
    end,
    config = function()
        mini_ai_setup()

        require("mini.align").setup {}

        require("mini.bracketed").setup {
            indent = { suffix = "" },
        }

        require("mini.comment").setup {
            mappings = { textobject = "ac" },
        }

        require("mini.extra").setup {}

        require("mini.indentscope").setup {
            draw = {
                delay = 20,
                animation = require("mini.indentscope").gen_animation.none(),
            },
            options = { indent_at_cursor = false },
        }

        require("mini.move").setup {}

        require("mini.splitjoin").setup {
            detect = { separator = "[,;]" },
            join = {
                hooks_post = { require("mini.splitjoin").gen_hook.pad_brackets { brackets = { "%b[]", "%b{}" } } },
            },
        }

        mini_surround_setup()

        if not vim.g.vscode then
            mini_clue_setup()

            mini_files_setup()

            local MiniMisc = require "mini.misc"
            MiniMisc.setup {}
            MiniMisc.setup_auto_root()

            mini_pick_setup()
        end
        if not vim.g.vscode and not vim.g.neovide then
            mini_animate_setup()
        end
    end,
}
