-- VS Code-like editing: multiple cursors, moving lines, auto-closing HTML tags and search & replace

-- [[ Multiple cursors ]]
-- Ctrl+D selects the word under the cursor, press it again to add the next occurrence.
--  Then edit normally (e.g. `c` to change, `i`/`a` to insert) and press <Esc> twice to exit.
--  See `:help visual-multi`
--
-- NOTE: These variables must be set before the plugin is loaded
vim.g.VM_default_mappings = 0
vim.g.VM_mouse_mappings = 1
vim.g.VM_maps = {
  ['Find Under'] = '<C-d>',
  ['Find Subword Under'] = '<C-d>',
  ['Select All'] = '<C-S-l>',
  ['Visual All'] = '<C-S-l>',
  ['Add Cursor Down'] = '<C-Down>',
  ['Add Cursor Up'] = '<C-Up>',
  ['Mouse Cursor'] = '<M-LeftMouse>',
}
vim.pack.add { 'https://github.com/mg979/vim-visual-multi' }

-- [[ Move lines ]]
-- Alt+h/j/k/l moves the current line (or selection) left/down/up/right.
--  Alt+Up/Down (like VS Code) is mapped in `lua/custom/keymaps.lua`.
--  See `:help mini.move`
require('mini.move').setup()

-- [[ Auto close and rename HTML/JSX tags ]]
vim.pack.add { 'https://github.com/windwp/nvim-ts-autotag' }
require('nvim-ts-autotag').setup {}

-- [[ Search & replace in all files ]]
-- Opens a panel like VS Code's search sidebar. Type in the "Search" and "Replace" fields,
--  then press <localleader>r (<Space>r) to replace everything. Press `g?` for help.
--  See `:help grug-far`
vim.pack.add { 'https://github.com/MagicDuck/grug-far.nvim' }
require('grug-far').setup {}
