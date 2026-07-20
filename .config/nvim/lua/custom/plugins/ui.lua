local M = {}

local function submit() end

M.setup = function()
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.ui.input = function(opts, on_confirm)
    local buf = vim.api.nvim_create_buf(false, false)
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].bufhidden = 'wipe'
    vim.bo[buf].swapfile = false

    local editor_width = vim.o.columns
    local editor_height = vim.o.lines
    local width = 50
    local height = 1
    local col = math.floor((editor_width - width) / 2)
    local row = math.floor((editor_height - height) / 4)

    local win = vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      border = 'rounded',
      style = 'minimal',
      zindex = 50,
      title = opts.prompt,
      title_pos = 'center',
    })

    local function copy_fg_with_normal_bg(group)
      local current = vim.api.nvim_get_hl(0, {
        name = group,
        link = false,
      })

      local normal = vim.api.nvim_get_hl(0, {
        name = 'Normal',
        link = false,
      })

      local unique_group = group .. '_' .. win
      vim.api.nvim_set_hl(0, unique_group, {
        fg = current.fg,
        bg = normal.bg,
        bold = current.bold,
        italic = current.italic,
        underline = current.underline,
        undercurl = current.undercurl,
        reverse = current.reverse,
        strikethrough = current.strikethrough,
      })

      return unique_group
    end

    local normal_group = copy_fg_with_normal_bg 'NormalFloat'
    local border_group = copy_fg_with_normal_bg 'FloatBorder'

    vim.wo[win].winhl = table.concat({
      'NormalFloat:' .. normal_group,
      'FloatBorder:' .. border_group,
      'FloatTitle:' .. border_group,
    }, ',')

    local initial = opts.default or ''
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
      initial,
    })
    vim.api.nvim_win_set_cursor(win, { 1, vim.str_utfindex(initial, 'utf-8') })

    vim.cmd 'startinsert!'

    local function close_input(value)
      if vim.api.nvim_get_mode().mode:match '^i' then vim.api.nvim_input '<C-\\><C-N>' end
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
        on_confirm(value)
      end)
    end

    vim.keymap.set('i', '<Esc>', function() close_input(nil) end, { buffer = buf, silent = true })

    vim.keymap.set('i', '<CR>', function()
      local new_name = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ''
      close_input(new_name)
    end, { buffer = buf, silent = true })
  end
end

return M
