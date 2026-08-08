local is_good_buf = require('custom.plugins.bufhelper').is_good_buf

--- @type integer[]
local buf_history = {}

vim.api.nvim_create_autocmd('BufDelete', {
  callback = function(args)
    local buf = args.buf
    if not vim.api.nvim_buf_is_valid(buf) then return end
    if not is_good_buf(buf) then return end
    table.insert(buf_history, buf)
  end,
})

vim.keymap.set('n', '<leader>bt', function()
  if #buf_history == 0 then
    print 'No bufs in history'
  else
    print(#buf_history)
    local buf = table.remove(buf_history)
    vim.fn.bufload(buf)
    vim.bo[buf].buflisted = true
    vim.api.nvim_set_current_buf(buf)
  end
end, { desc = 'Open recently closed buffer' })
