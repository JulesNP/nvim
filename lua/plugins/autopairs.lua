return {
    "windwp/nvim-autopairs",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    dependencies = "hrsh7th/nvim-cmp",
    config = function()
        local autopairs = require "nvim-autopairs"

        autopairs.setup {
            fast_wrap = {},
        }
        require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done {})

        local rule = require "nvim-autopairs.rule"
        local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
        local function paren_subpair(char)
            autopairs.add_rules {
                rule(char, char):with_pair(function(opts)
                    local pair = opts.line:sub(opts.col - 1, opts.col)
                    return vim.tbl_contains({
                        brackets[1][1] .. brackets[1][2],
                        brackets[2][1] .. brackets[2][2],
                        brackets[3][1] .. brackets[3][2],
                    }, pair)
                end),
            }
            for _, bracket in pairs(brackets) do
                autopairs.add_rules {
                    rule(bracket[1] .. char, char .. bracket[2])
                        :with_pair(function()
                            return false
                        end)
                        :with_move(function(opts)
                            return opts.prev_char:match(".%" .. bracket[2]) ~= nil
                        end)
                        :use_key(bracket[2]),
                }
            end
        end

        paren_subpair " "
        paren_subpair "|"
        require("nvim-autopairs").get_rules("'")[1].not_filetypes = { "fsharp" }
    end,
}
