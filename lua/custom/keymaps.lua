-- VS Code keyboard shortcuts
--
-- These are added on top of the regular Neovim keymaps, so everything you learn
-- in `:Tutor` keeps working. See `PANDUAN.md` for an overview of all shortcuts.
--
-- NOTE: Shortcuts such as Ctrl+Shift+P, Ctrl+/ and Ctrl+. only work in terminals
-- that support the kitty keyboard protocol (Alacritty, kitty, WezTerm, Ghostty, foot).
-- Most of them also have an alternative that works in every terminal.

local map = vim.keymap.set
local builtin = require 'telescope.builtin'

-- [[ File ]]

--- Saves the current file, asking for a file name if it doesn't have one yet (like "Save As")
local function save()
  local buftype = vim.bo.buftype
  if buftype ~= '' and buftype ~= 'acwrite' then return end

  if vim.api.nvim_buf_get_name(0) == '' then
    vim.ui.input({ prompt = 'Save as: ', completion = 'file' }, function(path)
      -- `++p` creates missing parent folders
      if path and path ~= '' then vim.cmd('write ++p ' .. vim.fn.fnameescape(path)) end
    end)
  else
    vim.cmd.write()
  end
end

map({ 'n', 'i', 'x' }, '<C-s>', save, { desc = 'Save file' })
map('n', '<C-n>', '<Cmd>enew<CR>', { desc = 'New file' })
map('n', '<C-q>', '<Cmd>qall<CR>', { desc = 'Quit Neovim' })

-- [[ Edit ]]
map('n', '<C-a>', 'ggVG', { desc = 'Select all' })
map('i', '<C-a>', '<Esc>ggVG', { desc = 'Select all' })
map('x', '<C-c>', 'y', { desc = 'Copy' })
map('x', '<C-x>', 'd', { desc = 'Cut' })
map('i', '<C-v>', '<C-r><C-o>+', { desc = 'Paste' })
map('c', '<C-v>', '<C-r>+', { desc = 'Paste' })
map('n', '<C-z>', 'u', { desc = 'Undo' })
map('i', '<C-z>', '<C-o>u', { desc = 'Undo' })
map('n', '<C-y>', '<C-r>', { desc = 'Redo' })
map('n', '<C-S-z>', '<C-r>', { desc = 'Redo' })
map('i', '<C-y>', '<C-o><C-r>', { desc = 'Redo' })
map('i', '<C-BS>', '<C-w>', { desc = 'Delete previous word' })

-- Toggle comment. Most terminals send Ctrl+/ as Ctrl+_
for _, key in ipairs { '<C-/>', '<C-_>' } do
  map('n', key, 'gcc', { remap = true, desc = 'Toggle comment' })
  map('x', key, 'gcgv', { remap = true, desc = 'Toggle comment' })
  map('i', key, '<Cmd>normal gcc<CR>', { desc = 'Toggle comment' })
end

-- Indent/outdent, keeping the selection so you can press it multiple times
map('x', '<Tab>', '>gv', { desc = 'Indent' })
map('x', '<S-Tab>', '<gv', { desc = 'Outdent' })
map('n', '<S-Tab>', '<<', { desc = 'Outdent' })
map('i', '<S-Tab>', '<C-d>', { desc = 'Outdent' })

-- Move line(s) up/down
map('n', '<M-Down>', function() MiniMove.move_line 'down' end, { desc = 'Move line down' })
map('n', '<M-Up>', function() MiniMove.move_line 'up' end, { desc = 'Move line up' })
map('x', '<M-Down>', function() MiniMove.move_selection 'down' end, { desc = 'Move selection down' })
map('x', '<M-Up>', function() MiniMove.move_selection 'up' end, { desc = 'Move selection up' })
map('i', '<M-Down>', '<Esc><Cmd>move .+1<CR>==gi', { desc = 'Move line down' })
map('i', '<M-Up>', '<Esc><Cmd>move .-2<CR>==gi', { desc = 'Move line up' })

-- Duplicate line(s) up/down
map({ 'n', 'i' }, '<S-M-Down>', '<Cmd>copy .<CR>', { desc = 'Duplicate line down' })
map({ 'n', 'i' }, '<S-M-Up>', '<Cmd>copy .-1<CR>', { desc = 'Duplicate line up' })
map('x', '<S-M-Down>', ":copy '><CR>gv", { desc = 'Duplicate selection down', silent = true })
map('x', '<S-M-Up>', ":copy '<-1<CR>gv", { desc = 'Duplicate selection up', silent = true })

-- Format the whole file (or the selection). Terminals without the kitty keyboard protocol send Alt+F.
for _, key in ipairs { '<S-M-f>', '<M-F>' } do
  map({ 'n', 'x' }, key, function() require('conform').format { async = true } end, { desc = 'Format document' })
end

-- [[ Search ]]
map('n', '<C-p>', builtin.find_files, { desc = 'Go to file (Quick Open)' })
map('n', '<C-S-p>', builtin.commands, { desc = 'Command palette' })
map('n', '<F1>', builtin.commands, { desc = 'Command palette' })
map('n', '<C-f>', '/', { desc = 'Find in file' })
map('n', '<C-S-f>', builtin.live_grep, { desc = 'Find in files' })
map('x', '<C-S-f>', builtin.grep_string, { desc = 'Find selection in files' })
map('n', '<C-S-h>', function() require('grug-far').open() end, { desc = 'Replace in files' })
map(
  'n',
  '<leader>sR',
  function() require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } } end,
  { desc = '[S]earch and [R]eplace in files' }
)
map('n', '<C-S-m>', builtin.diagnostics, { desc = 'Show all problems' })
map('n', '<F8>', function() vim.diagnostic.jump { count = 1 } end, { desc = 'Go to next problem' })
map('n', '<S-F8>', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Go to previous problem' })

-- [[ Explorer ]]
map('n', '<C-b>', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle file explorer' })
map('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle file [E]xplorer' })
map('n', '<C-S-e>', '<Cmd>Neotree reveal<CR>', { desc = 'Show current file in explorer' })

-- [[ Tabs ]]
map('n', '<C-PageDown>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next tab' })
map('n', '<C-PageUp>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous tab' })
map('n', '<C-Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next tab' })
map('n', '<C-S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous tab' })
map('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next tab' })
map('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous tab' })
map('n', '<C-S-PageDown>', '<Cmd>BufferLineMoveNext<CR>', { desc = 'Move tab right' })
map('n', '<C-S-PageUp>', '<Cmd>BufferLineMovePrev<CR>', { desc = 'Move tab left' })
for i = 1, 9 do
  map('n', '<M-' .. i .. '>', '<Cmd>BufferLineGoToBuffer ' .. i .. '<CR>', { desc = 'Go to tab ' .. i })
end
map('n', '<leader>x', function() MiniBufremove.delete() end, { desc = 'Close tab' })
map('n', '<leader>X', '<Cmd>BufferLineCloseOthers<CR>', { desc = 'Close other tabs' })

-- [[ Git ]]
map('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus (changed files)' })

-- [[ LSP ]]
-- Only available in files where a language server is running
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('vscode-lsp-attach', { clear = true }),
  callback = function(event)
    local function lsp_map(mode, keys, func, desc) map(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end

    lsp_map('n', '<F12>', builtin.lsp_definitions, 'Go to definition')
    lsp_map('n', '<S-F12>', builtin.lsp_references, 'Find all references')
    lsp_map('n', '<C-F12>', builtin.lsp_implementations, 'Go to implementation')
    lsp_map('n', '<F2>', vim.lsp.buf.rename, 'Rename symbol')
    lsp_map({ 'n', 'x' }, '<C-.>', vim.lsp.buf.code_action, 'Quick fix')
    lsp_map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction (quick fix)')
    lsp_map('n', '<C-S-o>', builtin.lsp_document_symbols, 'Go to symbol in file')
  end,
})
