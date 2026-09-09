---@param buf integer
---@param callback fun(err: lsp.ResponseError?, result: { data: vim.NIL, path: string }?)
local function typst_export_pdf(buf, callback)
  local client = vim.lsp.get_clients({
    name = 'tinymist',
    bufnr = buf,
  })[1]
  if not client then return end

  client:exec_cmd({
    title = 'Export PDF',
    command = 'tinymist.exportPdf',
    arguments = {
      vim.api.nvim_buf_get_name(buf),
    },
  }, { bufnr = buf }, function(err, result)
    if err then
      callback(err, nil)
    else
      callback(nil, result)
    end
  end)

  return 0
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('typst-filetype', { clear = true }),
  pattern = 'typst',
  callback = function(event)
    vim.keymap.set('n', '<leader>cco', function(args)
      local result = typst_export_pdf(event.buf, function(err, result)
        if err ~= nil then
          vim.notify('lsp error: ' .. err.message)
          return
        end
        if result == nil then
          vim.notify 'result nil'
          return
        end
        io.popen('zathura --fork ' .. result.path)
      end)

      if result == nil then
        vim.notify 'Could not get tinymist lsp client'
        return
      end
    end, { desc = 'Open pdf' })
  end,
})
