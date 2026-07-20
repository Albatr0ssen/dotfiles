local M = {}

COUNTER = 0

---@type integer[]
TERMINAL_BUFS = {}

---@param cmd string
local function create_float_term(cmd)
  local buf = vim.api.nvim_create_buf(false, false)

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].swapfile = false

  vim.api.nvim_buf_call(buf, function()
    vim.fn.jobstart(cmd, {
      term = true,
      pty = true,
      -- on_exit = function()
      --   if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, false) end
      -- end,
    })
    vim.cmd 'startinsert'
  end)

  vim.keymap.set('n', 'q', '<C-w>q', { buffer = buf, desc = 'Close terminal window' })

  return buf
end

local function dump_terminal_bufs()
  local msg = ''
  for _, value in ipairs(TERMINAL_BUFS) do
    msg = msg .. value .. ' '
  end
  vim.notify(msg, vim.log.levels.WARN)
end
---@param cmd string
---@param size number
---@param temp boolean
---@return function
function M.open(cmd, size, temp)
  local buf
  local id

  if not temp then
    COUNTER = COUNTER + 1
    id = COUNTER
    TERMINAL_BUFS[id] = create_float_term(cmd)
    vim.bo[TERMINAL_BUFS[id]].bufhidden = 'hide'
  end

  return function()
    if temp then
      buf = create_float_term(cmd)
      vim.bo[buf].bufhidden = 'wipe'
    else
      buf = TERMINAL_BUFS[id]
    end

    vim.cmd('echo ' .. buf)
    dump_terminal_bufs()

    local editor_width = vim.o.columns
    local editor_height = vim.o.lines
    local width = math.floor(editor_width * size)
    local height = math.floor(editor_height * size)
    local col = math.floor((editor_width - width) / 2)
    local row = math.floor((editor_height - height) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      border = 'rounded',
      style = 'minimal',
    })
  end
end

return M
