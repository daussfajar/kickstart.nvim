-- VS Code-like UI: editor tabs, breadcrumbs and a welcome screen

-- [[ Editor tabs ]]
-- Shows open files as tabs at the top of the screen.
--  Click a tab to switch to it, click its `x` (or middle-click the tab) to close it.
--  See `:help bufferline`

-- Closes a file without closing the window it was shown in, so the layout stays intact
require('mini.bufremove').setup()

vim.pack.add { { src = 'https://github.com/akinsho/bufferline.nvim', version = vim.version.range '*' } }
require('bufferline').setup {
  options = {
    close_command = function(bufnr) MiniBufremove.delete(bufnr) end,
    right_mouse_command = function(bufnr) MiniBufremove.delete(bufnr) end,
    middle_mouse_command = function(bufnr) MiniBufremove.delete(bufnr) end,
    -- Show the number of errors/warnings on each tab
    diagnostics = 'nvim_lsp',
    always_show_bufferline = true,
    -- Only show the close button when hovering a tab
    hover = { enabled = true, delay = 150, reveal = { 'close' } },
    -- Keep the tabs to the right of the file explorer, with an "EXPLORER" title above it
    offsets = {
      { filetype = 'neo-tree', text = 'EXPLORER', text_align = 'left', highlight = 'Directory', separator = true },
    },
  },
}

-- [[ Breadcrumbs ]]
-- Shows `folder > file > function` at the top of each window. Click a part to jump around.
--  See `:help dropbar`
vim.pack.add { 'https://github.com/Bekaboo/dropbar.nvim' }
vim.keymap.set('n', '<leader>;', function() require('dropbar.api').pick() end, { desc = 'Pick symbol in breadcrumbs' })

-- [[ Welcome screen ]]
-- Shown when Neovim is started without opening a file.
--  Press the first letter of an item (or move with the arrow keys and press <Enter>) to run it.
--  See `:help mini.starter`
local starter = require 'mini.starter'
local config_dir = vim.fn.stdpath 'config'
starter.setup {
  evaluate_single = true,
  items = {
    { section = 'Start', name = 'New file              Ctrl+N', action = 'enew' },
    { section = 'Start', name = 'Open file             Ctrl+P', action = 'Telescope find_files' },
    { section = 'Start', name = 'Find in files         Ctrl+Shift+F', action = 'Telescope live_grep' },
    { section = 'Start', name = 'Recent files', action = 'Telescope oldfiles' },
    { section = 'Start', name = 'Explorer              Ctrl+B', action = 'Neotree show' },
    { section = 'Start', name = 'Configuration', action = function() require('telescope.builtin').find_files { cwd = config_dir } end },
    { section = 'Start', name = 'Update plugins', action = 'lua vim.pack.update()' },
    { section = 'Start', name = 'Quit                  Ctrl+Q', action = 'qall' },
    starter.sections.recent_files(5, true, false),
  },
  content_hooks = {
    starter.gen_hook.adding_bullet(),
    starter.gen_hook.aligning('center', 'center'),
  },
}

-- The welcome screen uses Ctrl+P/Ctrl+N to move between items (the arrow keys do that too),
-- so bring back the VS Code shortcuts shown next to the items.
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  group = vim.api.nvim_create_augroup('custom-starter-keymaps', { clear = true }),
  callback = function()
    vim.keymap.set('n', '<C-p>', function() require('telescope.builtin').find_files() end, { buffer = 0, desc = 'Go to file (Quick Open)' })
    vim.keymap.set('n', '<C-n>', '<Cmd>enew<CR>', { buffer = 0, desc = 'New file' })
  end,
})
