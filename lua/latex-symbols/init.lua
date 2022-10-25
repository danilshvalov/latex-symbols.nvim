local config = require("latex-symbols.config")
local conceal = require("latex-symbols.conceal")

local M = {}

M.add_conceals = conceal.add_conceals
M.add_symbol_conceals = conceal.add_symbol_conceals
M.add_blackboard_conceals = conceal.add_blackboard_conceals

M.setup = function(opts)
    config.setup(opts)
    conceal.add_default_symbols()

    vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("Conceal", {}),
        pattern = "*.tex",
        callback = function()
            local first_line = 0
            local last_line = vim.fn.line("$") - 1
            conceal.render_conceals(first_line, last_line)

            vim.api.nvim_buf_attach(0, true, {
                on_lines = function(_, _, _, first, _, last)
                    conceal.render_conceals(first, last)
                end,
            })
        end,
    })
end

return M
