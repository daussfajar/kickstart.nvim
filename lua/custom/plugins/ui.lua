-- VS Code-like UI: editor tabs and breadcrumbs

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

-- NOTE: The welcome screen is configured in `lua/custom/plugins/welcome.lua`
