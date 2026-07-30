vim.pack.add { 'https://github.com/nvim-svelte/nvim-svelte-check' }
require('svelte-check').setup {
  command = 'pnpm check',
}

--- @return boolean
local function is_svelte_project()
  local cwd = vim.fn.getcwd()
  local svelte_config = vim.fs.find('svelte.config.js', {
    path = cwd,
    upward = true,
  })[1]
  return svelte_config ~= nil
end

local function svelte_keymaps()
  local enabled = is_svelte_project()

  local modes = 'n'
  local lhs = '<leader>ccs'
  if enabled then
    vim.keymap.set(modes, lhs, '<cmd>SvelteCheck<CR>')
  else
    pcall(vim.keymap.del, modes, lhs)
  end
end

local group = vim.api.nvim_create_augroup('SvelteProject', {})

vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  callback = svelte_keymaps,
})

vim.api.nvim_create_autocmd('DirChanged', {
  group = group,
  callback = svelte_keymaps,
})
