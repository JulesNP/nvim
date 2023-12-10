local function confirm_discard_changes(all_buffers)
    local buf_list = all_buffers == false and { 0 } or vim.api.nvim_list_bufs()
    local unsaved = vim.tbl_filter(function(buf_id)
        return vim.bo[buf_id].modified and vim.bo[buf_id].buflisted
    end, buf_list)

    if #unsaved == 0 then
        return true
    end

    for _, buf_id in ipairs(unsaved) do
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf_id), ":~:.")
        local result = vim.fn.confirm(
            string.format('Save changes to "%s"?', name ~= "" and name or "Untitled"),
            "&Yes\n&No\n&Cancel",
            1,
            "Question"
        )

        if result == 1 then
            if buf_id ~= 0 then
                vim.cmd("buffer " .. buf_id)
            end
            vim.cmd "update"
        elseif result == 0 or result == 3 then
            return false
        end
    end

    return true
end

local function mini_ai_setup()
    local gen_ai_spec = require("mini.extra").gen_ai_spec
    local ts = require("mini.ai").gen_spec.treesitter
    require("mini.ai").setup {
        custom_textobjects = {
            A = ts { a = "@assignment.lhs", i = "@assignment.rhs" },
            C = ts { a = "@class.outer", i = "@class.inner" },
            F = ts { a = "@function.outer", i = "@function.inner" },
            N = gen_ai_spec.number(),
            a = require("mini.ai").gen_spec.argument { separator = "[,;]" },
            c = ts { a = "@comment.outer", i = "@comment.inner" },
            d = gen_ai_spec.diagnostic(),
            g = gen_ai_spec.buffer(),
            k = ts { a = "@block.outer", i = "@block.inner" },
            m = ts { a = "@function.outer", i = "@function.inner" },
            o = ts {
                a = { "@conditional.outer", "@loop.outer" },
                i = { "@conditional.inner", "@loop.inner" },
            },
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
            { mode = "n", keys = "s" },
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

    vim.keymap.set("n", "\\", function()
        if not MiniFiles.close() then
            MiniFiles.open()
        end
    end, { desc = "Open file browser" })
    vim.keymap.set("n", "-", function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
        MiniFiles.reveal_cwd()
    end, { desc = "Open file browser" })
end

local function mini_indentscope_setup()
    require("mini.indentscope").setup {
        draw = {
            delay = 20,
            animation = require("mini.indentscope").gen_animation.none(),
        },
        options = { indent_at_cursor = false },
        symbol = "▏",
    }
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

local function mini_map_setup()
    local MiniMap = require "mini.map"
    MiniMap.setup {
        integrations = {
            MiniMap.gen_integration.builtin_search(),
            MiniMap.gen_integration.gitsigns(),
            MiniMap.gen_integration.diagnostic(),
        },
        symbols = {
            encode = MiniMap.gen_encode_symbols.dot "4x2",
        },
        window = {
            zindex = 30,
        },
    }
    vim.keymap.set("n", "<leader>tm", function()
        MiniMap.toggle()
    end, { desc = "Toggle mini.map" })
    for _, key in ipairs { "n", "N", "*", "#" } do
        vim.keymap.set("n", key, key .. "<cmd>lua MiniMap.refresh({}, {lines = false, scrollbar = false})<cr>")
    end
    vim.keymap.set(
        "n",
        "<esc>",
        "<cmd>nohlsearch<bar>diffupdate<bar>lua MiniMap.refresh({}, {lines = false, scrollbar = false})<cr>",
        { desc = "Clear search highlights" }
    )
end

local function mini_pick_setup()
    local MiniPick = require "mini.pick"
    MiniPick.setup {
        mappings = {
            choose_alt = {
                char = "<nl>",
                func = function()
                    vim.api.nvim_input "<cr>"
                end,
            },
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
    MiniPick.registry.read_session = function()
        local items = vim.tbl_values(require("mini.sessions").detected)
        local current = vim.fn.fnamemodify(vim.v.this_session, ":t")
        table.sort(items, function(a, b)
            if a.name == current then
                return false
            elseif b.name == current then
                return true
            end
            return a.modify_time > b.modify_time
        end)
        for _, value in pairs(items) do
            value.text = value.name .. " (" .. value.type .. ")"
        end
        local selection = MiniPick.start {
            source = {
                items = items,
                name = "Read Session",
                choose = function() end,
            },
        }
        if selection ~= nil then
            if confirm_discard_changes() then
                require("mini.sessions").read(selection.name, { force = true })
            end
        end
    end
    local MiniFuzzy = require "mini.fuzzy"
    local MiniVisits = require "mini.visits"
    MiniPick.registry.frecency = function()
        local visits_index = MiniVisits.get_index()[vim.loop.cwd()]
        if visits_index == nil then
            MiniPick.builtin.files()
        else
            local current_file = vim.fn.expand "%:p"
            MiniPick.builtin.files(nil, {
                source = {
                    match = function(stritems, indices, query)
                        local prompt = vim.pesc(table.concat(query))
                        local res = {}

                        for _, index in ipairs(indices) do
                            local path = stritems[index]
                            local match_score = prompt == "" and 0 or MiniFuzzy.match(prompt, path).score
                            if match_score >= 0 then
                                local full_path = vim.fn.fnamemodify(path, ":p")
                                -- NOTE: Currently doesn't match files with uppercase characters
                                local visits = visits_index[full_path]
                                table.insert(res, {
                                    count = visits == nil and 0 or visits.count,
                                    index = index,
                                    latest = visits == nil and 0 or visits.latest,
                                    score = full_path == current_file and 9999 or match_score, -- Score current file last
                                })
                            end
                        end

                        local function set_rank(key)
                            local last, ties = -1, 0
                            for index, item in ipairs(res) do
                                local value = item[key]
                                ties = last == value and ties + 1 or 0
                                last = value
                                item[key] = index - ties - 1
                            end
                        end

                        table.sort(res, function(a, b)
                            return a.count > b.count
                        end)
                        set_rank "count"

                        table.sort(res, function(a, b)
                            return a.latest > b.latest
                        end)
                        set_rank "latest"

                        table.sort(res, function(a, b)
                            return a.score + (a.count + a.latest) * 6 < b.score + (b.count + b.latest) * 6
                        end)

                        return vim.tbl_map(function(val)
                            return val.index
                        end, res)
                    end,
                },
            })
        end
    end

    vim.keymap.set("n", "<leader>f<leader>", "<cmd>Pick resume<cr>", { desc = "Resume last search" })
    vim.keymap.set("n", "<leader>fb", function()
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
    end, { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fC", "<cmd>Pick list scope='change'<cr>", { desc = "Find in changelist" })
    vim.keymap.set("n", "<leader>:", "<cmd>Pick commands<cr>", { desc = "Find commands" })
    vim.keymap.set("n", "<leader>fe", "<cmd>Pick explorer<cr>", { desc = "Find via file explorer" })
    vim.keymap.set("n", "<leader>fD", "m'<cmd>Pick lsp scope='declaration'<cr>", { desc = "Find LSP declaration" })
    vim.keymap.set("n", "<leader>fd", "m'<cmd>Pick lsp scope='definition'<cr>", { desc = "Find LSP definition" })
    vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find files" })
    vim.keymap.set("n", "<leader>gb", "<cmd>Pick git_branches<cr>", { desc = "Find branches" })
    vim.keymap.set("n", "<leader>gc", "<cmd>Pick git_commits<cr>", { desc = "Find commits" })
    vim.keymap.set("n", "<leader>gd", "<cmd>Pick git_files scope='deleted'<cr>", { desc = "Find deleted files" })
    vim.keymap.set("n", "<leader>gf", "<cmd>Pick git_files<cr>", { desc = "Find tracked files" })
    vim.keymap.set("n", "<leader>gh", "<cmd>Pick git_hunks<cr>", { desc = "Find hunks" })
    vim.keymap.set("n", "<leader>gi", "<cmd>Pick git_files scope='ignored'<cr>", { desc = "Find ignored files" })
    vim.keymap.set("n", "<leader>gm", "<cmd>Pick git_files scope='modified'<cr>", { desc = "Find modified files" })
    vim.keymap.set("n", "<leader>gu", "<cmd>Pick git_files scope='untracked'<cr>", { desc = "Find untracked files" })
    vim.keymap.set("n", "<leader>fG", "<cmd>Pick grep<cr>", { desc = "Find with grep" })
    vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Find with live grep" })
    vim.keymap.set("n", "<leader>fH", "<cmd>Pick hl_groups<cr>", { desc = "Find highlight groups" })
    vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Find help documents" })
    vim.keymap.set("n", "<leader>fi", "<cmd>Pick diagnostic<cr>", { desc = "Find diagnostics" })
    vim.keymap.set("n", "<leader>fj", "<cmd>Pick list scope='jump'<cr>", { desc = "Find in jumplist" })
    vim.keymap.set("n", "<leader>fk", "<cmd>Pick keymaps<cr>", { desc = "Find keymaps" })
    vim.keymap.set("n", "<leader>fl", "<cmd>Pick buf_lines<cr>", { desc = "Find buffer lines" })
    vim.keymap.set("n", "<leader>fM", "<cmd>Pick marks<cr>", { desc = "Find marks" })
    vim.keymap.set("n", "<leader>fo", "<cmd>Pick options<cr>", { desc = "Find Neovim options" })
    vim.keymap.set("n", "<leader>fo", "<cmd>Pick oldfiles<cr>", { desc = "Find oldfiles" })
    vim.keymap.set("n", "<leader>fR", "<cmd>Pick registers<cr>", { desc = "Find registers" })
    vim.keymap.set("n", "<leader>fr", "m'<cmd>Pick lsp scope='references'<cr>", { desc = "Find LSP references" })
    vim.keymap.set(
        "n",
        "<leader>fS",
        "m'<cmd>Pick lsp scope='workspace_symbol'<cr>",
        { desc = "Find LSP workspace symbol" }
    )
    vim.keymap.set(
        "n",
        "<leader>fs",
        "m'<cmd>Pick lsp scope='document_symbol'<cr>",
        { desc = "Find LSP document symbol" }
    )
    vim.keymap.set("n", "<leader>fT", "<cmd>Pick treesitter<cr>", { desc = "Find treesitter nodes" })
    vim.keymap.set(
        "n",
        "<leader>ft",
        "<cmd>Pick lsp scope='type_definition'<cr>",
        { desc = "Find LSP type definition" }
    )
    vim.keymap.set("n", "<leader>fq", "<cmd>Pick list scope='quickfix'<cr>", { desc = "Find in quickfix list" })
    vim.keymap.set("n", "<leader>fw", "<cmd>Pick grep pattern='<cword>'<cr>", { desc = "Find current word" })
    vim.keymap.set("n", "<leader>fz", "<cmd>Pick spellsuggest<cr>", { desc = "Find spelling suggestions" })
    vim.keymap.set("n", "z=", function()
        if vim.v.count > 0 then
            vim.api.nvim_feedkeys(vim.v.count .. "z=", "n", false)
        else
            vim.cmd "Pick spellsuggest"
        end
    end, { desc = "Find spelling suggestions" })
end

local function mini_sessions_setup()
    local MiniSessions = require "mini.sessions"
    MiniSessions.setup {}
    vim.keymap.set("n", "<leader>sd", function()
        MiniSessions.select "delete"
    end, { desc = "Delete session" })
    vim.keymap.set("n", "<leader>ss", "<cmd>Pick read_session<cr>", { desc = "Select session" })
    vim.keymap.set("n", "<leader>sw", function()
        vim.ui.input({
            prompt = "Session Name: ",
            default = vim.v.this_session ~= "" and vim.v.this_session or vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
        }, function(input)
            if input ~= nil then
                MiniSessions.write(input, { force = true })
            end
        end)
    end, { desc = "Save session" })
    vim.keymap.set("n", "<leader>sx", function()
        if confirm_discard_changes() then
            vim.v.this_session = ""
            vim.cmd "%bwipeout!"
            vim.cmd "cd ~"
        end
    end, { desc = "Clear current session" })
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

        require("mini.fuzzy").setup {}

        require("mini.move").setup {}

        local MiniOperators = require "mini.operators"
        MiniOperators.setup { exchange = { prefix = "" }, replace = { prefix = "s" } }
        MiniOperators.make_mappings("exchange", { textobject = "sx", line = "sxx", selection = "X" })
        vim.keymap.set("n", "S", "s$", { remap = true })
        vim.keymap.set("n", "sX", "sx$", { remap = true })

        require("mini.splitjoin").setup {
            detect = { separator = "[,;]" },
            join = {
                hooks_post = { require("mini.splitjoin").gen_hook.pad_brackets { brackets = { "%b[]", "%b{}" } } },
            },
        }

        mini_surround_setup()

        if not vim.g.vscode then
            mini_clue_setup()

            require("mini.bufremove").setup {}
            vim.keymap.set("n", "<leader>x", function()
                if confirm_discard_changes(false) then
                    require("mini.bufremove").delete(0, true)
                end
            end, { desc = "Close buffer" })

            mini_files_setup()

            mini_indentscope_setup()

            mini_map_setup()

            local MiniMisc = require "mini.misc"
            MiniMisc.setup {}
            MiniMisc.setup_auto_root()
            vim.keymap.set("n", "<leader>z", function()
                MiniMisc.zoom(0, { width = vim.o.columns, height = vim.o.lines })
            end, { desc = "Zoom current buffer" })

            mini_pick_setup()

            mini_sessions_setup()

            require("mini.statusline").setup {}

            require("mini.visits").setup {}
            vim.keymap.set("n", "<leader><leader>", "<cmd>Pick frecency<cr>", { desc = "Select recent file" })
        end
        if not vim.g.vscode and not vim.g.neovide then
            mini_animate_setup()
        end
    end,
}
