local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"

-- Makes sure aliased options are set correctly
local function apply_cwd_only_aliases(opts)
    local has_cwd_only = opts.cwd_only ~= nil
    local has_only_cwd = opts.only_cwd ~= nil

    if has_only_cwd and not has_cwd_only then
        -- Internally, use cwd_only
        opts.cwd_only = opts.only_cwd
        opts.only_cwd = nil
    end

    return opts
end

local function oldfiles_list(opts)
    opts = apply_cwd_only_aliases(opts)
    opts.include_current_session = vim.F.if_nil(opts.include_current_session, true)

    local current_buffer = vim.api.nvim_get_current_buf()
    local current_file = vim.api.nvim_buf_get_name(current_buffer)
    local results = {}

    for _, buffer in ipairs(vim.split(vim.fn.execute ":buffers! t", "\n", {})) do
        local match = tonumber(string.match(buffer, "%s*(%d+)"))
        local open_by_lsp = string.match(buffer, "line 0$")
        if match and not open_by_lsp then
            local file = vim.api.nvim_buf_get_name(match)
            if vim.loop.fs_stat(file) and match ~= current_buffer then
                table.insert(results, file)
            end
        end
    end

    for _, file in ipairs(vim.v.oldfiles) do
        if vim.loop.fs_stat(file) and not vim.tbl_contains(results, file) and file ~= current_file then
            table.insert(results, file)
        end
    end

    local cwd = vim.loop.cwd()
    if cwd ~= nil then
        cwd = cwd:gsub([[\]], [[\\]])
    end
    results = vim.tbl_filter(function(file)
        return vim.fn.matchstrpos(file, cwd)[2] ~= -1
    end, results)

    return results
end

return function(opts)
    opts = opts or {}
    local results = oldfiles_list(opts)

    pickers
        .new(opts, {
            prompt_title = "Enhanced Find Files",
            results_title = "Files",
            finder = finders.new_table {
                results = results,
                entry_maker = make_entry.gen_from_file(opts),
            },
            previewer = conf.file_previewer(opts),
            sorter = conf.file_sorter(opts),
            on_input_filter_cb = function(prompt)
                local is_empty = prompt == nil or prompt == ""
                if is_empty then
                    return {
                        prompt = prompt,
                        updated_finder = finders.new_table {
                            results = results,
                            entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
                        },
                    }
                end

                local find_command = {
                    "fd",
                    "--type=file",
                    "--hidden",
                    "--exclude=.git",
                    "--exclude=.idea",
                    "--exclude=node_modules",
                    "--exclude=dist",
                    "--exclude=out",
                    "--exclude=.next",
                    "--exclude=.cache",
                }

                local command = find_command[1]
                local hidden = opts.hidden
                local no_ignore = opts.no_ignore
                local no_ignore_parent = opts.no_ignore_parent
                local follow = opts.follow
                local search_dirs = opts.search_dirs
                local search_file = opts.search_file

                if search_dirs then
                    for k, v in pairs(search_dirs) do
                        search_dirs[k] = vim.fn.expand(v)
                    end
                end

                if command == "fd" or command == "fdfind" or command == "rg" then
                    if hidden then
                        table.insert(find_command, "--hidden")
                    end
                    if no_ignore then
                        table.insert(find_command, "--no-ignore")
                    end
                    if no_ignore_parent then
                        table.insert(find_command, "--no-ignore-parent")
                    end
                    if follow then
                        table.insert(find_command, "-L")
                    end
                    if search_file then
                        if command == "rg" then
                            table.insert(find_command, "-g")
                            table.insert(find_command, "*" .. search_file .. "*")
                        else
                            table.insert(find_command, search_file)
                        end
                    end
                    if search_dirs then
                        if command ~= "rg" and not search_file then
                            table.insert(find_command, ".")
                        end
                        for _, v in pairs(search_dirs) do
                            table.insert(find_command, v)
                        end
                    end
                end

                if opts.cwd then
                    opts.cwd = vim.fn.expand(opts.cwd)
                end

                opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

                return {
                    prompt = prompt,
                    updated_finder = finders.new_oneshot_job(find_command, opts),
                }
            end,
        })
        :find()
end
