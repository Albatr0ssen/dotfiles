vim.pack.add { 'https://github.com/nvim-svelte/nvim-svelte-check' }
require('svelte-check').setup {
  command = 'pnpm check',
}
