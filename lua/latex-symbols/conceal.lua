local config = require("latex-symbols.config")
local utils = require("latex-symbols.utils")

local M = {}

local function create_concealer(concealer)
    return function(conceals, opts)
        opts = opts or {}
        opts.concealer = concealer
        M.add_conceals(conceals, opts)
    end
end

M.add_conceals = function(conceals, opts)
    opts = opts or {}

    if not opts.concealer then
        opts.concealer = function(symbol)
            return utils.literalize_string(symbol)
        end
    end

    for symbol, conceal in pairs(conceals) do
        local pattern = opts.concealer(symbol)

        if opts.disable then
            config.options.conceals[pattern] = nil
        else
            config.options.conceals[pattern] = conceal
        end
    end
end

M.add_symbol_conceals = create_concealer(function(symbol)
    return "(\\" .. utils.literalize_string(symbol) .. ")%f[^%w]"
end)

M.add_blackboard_conceals = create_concealer(function(symbol)
    return "(\\mathbb{" .. utils.literalize_string(symbol) .. "})"
end)

local extmarks = {}

local ns_id = vim.api.nvim_create_namespace("latex-symbols")

M.render_conceals = function(first_line, last_line)
    local lines = vim.api.nvim_buf_get_lines(0, first_line, last_line, false)
    for row_offset, line in pairs(lines) do
        local row = first_line + row_offset - 1
        if not extmarks[row] then
            extmarks[row] = {}
        end

        for _, ext_id in ipairs(extmarks[row]) do
            vim.api.nvim_buf_del_extmark(0, ns_id, ext_id)
        end

        for pattern, replace in pairs(config.options.conceals) do
            local col = 0
            while true do
                local start_col, end_col, capture = line:find(pattern, col)
                if not start_col or not capture then
                    break
                end

                table.insert(
                    extmarks[row],
                    vim.api.nvim_buf_set_extmark(
                        0,
                        ns_id,
                        row,
                        start_col - 1,
                        { end_col = start_col + #capture - 1, conceal = replace }
                    )
                )
                col = end_col
            end
        end
    end
end

M.add_default_symbols = function()
    M.add_symbol_conceals({
        ["alpha"] = "??",
        ["beta"] = "??",
        ["gamma"] = "??",
        ["delta"] = "??",
        ["epsilon"] = "??",
        ["varepsilon"] = "??",
        ["zeta"] = "??",
        ["eta"] = "??",
        ["theta"] = "??",
        ["vartheta"] = "??",
        ["iota"] = "??",
        ["kappa"] = "??",
        ["lambda"] = "??",
        ["mu"] = "??",
        ["nu"] = "??",
        ["xi"] = "??",
        ["pi"] = "??",
        ["varpi"] = "??",
        ["rho"] = "??",
        ["varrho"] = "??",
        ["sigma"] = "??",
        ["varsigma"] = "??",
        ["tau"] = "??",
        ["upsilon"] = "??",
        ["phi"] = "??",
        ["varphi"] = "??",
        ["chi"] = "??",
        ["psi"] = "??",
        ["omega"] = "??",
        ["Gamma"] = "??",
        ["Delta"] = "??",
        ["Theta"] = "??",
        ["Lambda"] = "??",
        ["Xi"] = "??",
        ["Pi"] = "??",
        ["Sigma"] = "??",
        ["Upsilon"] = "??",
        ["Phi"] = "??",
        ["Chi"] = "??",
        ["Psi"] = "??",
        ["Omega"] = "??",
        ["ldots"] = "???",
        ["leq"] = "???",
        ["geq"] = "???",
        ["neq"] = "???",
        ["partial"] = "???",
        ["int"] = "???",
        ["iint"] = "???",
        ["iiint"] = "???",
        ["notin"] = "???",
        ["in"] = "???",
        ["infty"] = "???",
        ["sqrt"] = "???",
        ["cdot"] = "??",
        ["to"] = "???",
        ["sum"] = "??",
        ["implies"] = "???",
        ["sim"] = "~",
        ["quad"] = "???",
        ["qquad"] = "???",
    })

    M.add_blackboard_conceals({
        A = "????",
        B = "????",
        C = "???",
        D = "????",
        E = "????",
        F = "????",
        G = "????",
        I = "????",
        J = "????",
        K = "????",
        L = "????",
        M = "????",
        N = "???",
        O = "????",
        P = "???",
        Q = "???",
        R = "???",
        S = "????",
        T = "????",
        U = "????",
        V = "????",
        W = "????",
        X = "????",
        Y = "????",
        Z = "???",
    })

    M.add_conceals({
        ["\\;"] = "???",
    })
end

return M
