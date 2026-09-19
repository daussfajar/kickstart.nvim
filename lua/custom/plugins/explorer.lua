-- File explorer sidebar, like VS Code's Explorer
--  Based on `lua/kickstart/plugins/neo-tree.lua`.
--
-- Open it with Ctrl+B, <leader>e or `\`, and press `?` inside it to see all its keys.
--  See `:help neo-tree`

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  -- Close Neovim instead of leaving only the explorer open
  close_if_last_window = true,
  window = {
    width = 32,
    mappings = {
      -- Let <Space> keep working as the leader key inside the explorer
      ['<space>'] = 'none',
      -- Close the explorer with the same keys that open it
      ['\\'] = 'close_window',
      ['<C-b>'] = 'close_window',
    },
  },
  filesystem = {
    -- Highlight the file you are editing in the tree
    follow_current_file = { enabled = true },
    -- Update the tree when files are created/deleted outside of Neovim
    use_libuv_file_watcher = true,
    -- Like VS Code, show dotfiles (e.g. `.env`) and git-ignored files, but never `.git`
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
      never_show = { '.git', '.DS_Store' },
    },
  },
}
