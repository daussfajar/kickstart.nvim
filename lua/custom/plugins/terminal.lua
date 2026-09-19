-- Integrated terminal, like VS Code's bottom panel
--
-- Toggle it with Ctrl+` (or Ctrl+\ in terminals that can't send Ctrl+`).
--  Prefix it with a number to get more terminals, e.g. `2` then Ctrl+\ opens a second one.
--  Press <Esc><Esc> to leave terminal mode, e.g. to scroll or copy text.
--  See `:help toggleterm`

vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }
require('toggleterm').setup {
  open_mapping = { [[<C-`>]], [[<C-\>]] },
  direction = 'horizontal',
  size = function(term)
    if term.direction == 'vertical' then return math.floor(vim.o.columns * 0.4) end
    return 15
  end,
  float_opts = { border = 'rounded' },
}

-- [[ Git ]]
-- Lazygit is a full git UI (stage, commit, push, branches, ...), shown in a floating terminal.
--  It has to be installed separately: `sudo pacman -S lazygit`
local lazygit
vim.keymap.set('n', '<leader>gg', function()
  if vim.fn.executable 'lazygit' == 0 then
    vim.notify('lazygit is not installed. Install it with: sudo pacman -S lazygit', vim.log.levels.WARN)
    return
  end
  lazygit = lazygit or require('toggleterm.terminal').Terminal:new { cmd = 'lazygit', direction = 'float', hidden = true }
  lazygit:toggle()
end, { desc = '[G]it: open Lazy[g]it' })
