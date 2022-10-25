local M = {}

local default_config = {
    conceals = {},
}

M.options = {}

M.setup = function(opts)
    M.options = vim.tbl_deep_extend("force", default_config, opts or {})
end

return M
