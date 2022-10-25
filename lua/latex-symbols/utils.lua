local M = {}

M.literalize_string = function(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)
        return "%" .. c
    end)
end

return M
