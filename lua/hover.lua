--- Custom hover function to filter out usless links from fsautocomplete lsp
return function(_, result, ctx, config)
    config = config or {}
    config.focus_id = ctx.method
    if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
        -- Ignore result since buffer changed. This happens for slow language servers.
        return
    end
    if not (result and result.contents) then
        if config.silent ~= true then
            vim.notify "No information available"
        end
        return
    end
    local format = "markdown"
    local contents ---@type string[]
    if type(result.contents) == "table" and result.contents.kind == "plaintext" then
        format = "plaintext"
        contents = vim.split(result.contents.value or "", "\n", { trimempty = true })
    else
        contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    end
    if vim.tbl_isempty(contents) then
        if config.silent ~= true then
            vim.notify "No information available"
        end
        return
    end

    -- Filter out `fsharp.showDocumentation` links
    contents = vim.tbl_filter(function(str)
        return str:find "<a href='command:fsharp.showDocumentation?" == nil
    end, contents)

    return vim.lsp.util.open_floating_preview(contents, format, config)
end
