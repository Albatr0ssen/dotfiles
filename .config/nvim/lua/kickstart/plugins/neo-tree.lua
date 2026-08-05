-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local manager = require 'neo-tree.sources.manager'
    local renderer = require 'neo-tree.ui.renderer'
    local command = require 'neo-tree.command'

    local state = manager.get_state 'filesystem'

    if renderer.tree_is_visible(state) then command.execute {
      action = 'show',
      source = 'filesystem',
      reveal = true,
    } end
  end,
})

vim.keymap.set(
  'n',
  '<leader>e',
  function()
    require('neo-tree.command').execute {
      toggle = true,
      action = 'focus',
      source = 'filesystem',
      position = 'left',
      reveal = true,
    }
  end,
  { desc = 'NeoTree reveal', silent = true }
)

require('neo-tree').setup {
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
    },
    window = {
      popup = {
        border = 'rounded',
      },
      mappings = {
        ['\\'] = 'close_window',
        ['l'] = 'open',
        -- ['H'] = '',
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
