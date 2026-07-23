-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '<leader>e', function()
  local reveal_file = vim.fn.expand '%:p'
  if reveal_file == '' then
    reveal_file = vim.fn.getcwd()
  else
    local f = io.open(reveal_file, 'r')
    if f then
      f.close(f)
    else
      reveal_file = vim.fn.getcwd()
    end
  end
  require('neo-tree.command').execute {
    toggle = true,
    action = 'focus',
    source = 'filesystem',
    position = 'left',
    reveal_file = reveal_file,
    reveal_force_cwd = true,
  }
end, { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
    },
    window = {
      popup = {
        border = 'rounded',
      },
      mappings = {
        ['\\'] = 'close_window',
        ['l'] = 'open',
        ['h'] = 'navigate_up',
        ['P'] = {
          'toggle_preview',
          config = {
            use_float = true,
            -- use_image_nvim = true,
            -- use_snacks_image = true,
            -- title = 'Neo-tree Preview',
          },
        },
      },
    },
  },
}
