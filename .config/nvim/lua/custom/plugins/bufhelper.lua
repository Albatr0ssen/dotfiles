local M = {}

---@param buf integer
M.is_good_buf = function(buf) return vim.bo[buf].buflisted and vim.bo[buf].buftype == '' and vim.bo[buf].filetype ~= '' end

return M
