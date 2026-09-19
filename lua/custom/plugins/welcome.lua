-- Welcome screen, like VS Code's Welcome page
--
-- Shown when Neovim is started without opening a file. To run an item:
--  - press the key in the box on its left (e.g. `o` for "Open File..." or `1` for the first recent file),
--  - or move with the arrow keys (or `j`/`k`) and press <Enter>,
--  - or click it with the mouse.
--
-- The layout adapts to the window: the logo is hidden and fewer recent files are shown
-- when the terminal is small.
--  See `:help mini.starter`

local starter = require 'mini.starter'
local config_dir = vim.fn.stdpath 'config'

-- Icons from VS Code's own icon set ("codicons"), which is included in Nerd Fonts
local icons = {
  new_file = '\u{EA7F}',
  go_to_file = '\u{EA94}',
  search = '\u{EA6D}',
  files = '\u{EAF0}',
  history = '\u{EA82}',
  settings = '\u{EB51}',
  book = '\u{EAA4}',
  sync = '\u{EA77}',
  quit = '\u{EA6E}',
  folder = '\u{EA83}',
  git_branch = '\u{EC6F}',
  lightbulb = '\u{EA61}',
}
if not vim.g.have_nerd_font then
  for name in pairs(icons) do
    icons[name] = ''
  end
end

local logo = {
  [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
  [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
  [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
  [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
  [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
  [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
}

local tips = {
  'Tekan Spasi lalu tunggu sebentar untuk melihat semua shortcut',
  'Ctrl+P membuka file mana pun hanya dengan mengetik namanya',
  'Tekan Ctrl+D berulang kali untuk mengedit kata yang sama sekaligus',
  'Tersesat? Tekan Esc beberapa kali untuk kembali ke Normal mode',
  'F12 untuk go to definition, lalu Ctrl+O untuk kembali',
  'Alt+↑/↓ memindahkan baris, Shift+Alt+↓ menduplikatnya',
  'Ctrl+` membuka terminal, Esc Esc untuk scroll di dalamnya',
  'Ketik :Tutor untuk belajar dasar-dasar Vim (sekitar 30 menit)',
  'ciw mengganti satu kata, ci" mengganti isi tanda kutip',
  'Spasi t f menyalakan format otomatis saat menyimpan',
  'Tekan g di layar ini untuk membuka panduan lengkap',
}
-- Pick one tip per Neovim session
local tip = tips[math.floor(vim.uv.hrtime() / 1000) % #tips + 1]

-- [[ Items ]]

local function edit(path) vim.cmd('edit ' .. vim.fn.fnameescape(path)) end

-- `key`, `icon` and `hint` are our own fields, used by the layout below
local start_items = {
  { key = 'n', icon = icons.new_file, name = 'New File...', hint = 'Ctrl+N', action = 'enew' },
  { key = 'o', icon = icons.go_to_file, name = 'Open File...', hint = 'Ctrl+P', action = 'Telescope find_files' },
  { key = 'f', icon = icons.search, name = 'Find in Files', hint = 'Ctrl+Shift+F', action = 'Telescope live_grep' },
  { key = 'e', icon = icons.files, name = 'Explorer', hint = 'Ctrl+B', action = 'Neotree focus' },
  { key = 'r', icon = icons.history, name = 'Recent Files', hint = 'Space s .', action = 'Telescope oldfiles' },
  {
    key = 's',
    icon = icons.settings,
    name = 'Settings',
    hint = 'Space s n',
    action = function() require('telescope.builtin').find_files { cwd = config_dir } end,
  },
  { key = 'g', icon = icons.book, name = 'Guide', hint = 'PANDUAN.md', action = function() edit(vim.fs.joinpath(config_dir, 'PANDUAN.md')) end },
  { key = 'u', icon = icons.sync, name = 'Update Plugins', hint = '', action = function() vim.pack.update() end },
  { key = 'q', icon = icons.quit, name = 'Quit', hint = 'Ctrl+Q', action = 'qall' },
}
for _, item in ipairs(start_items) do
  item.section = 'Start'
end

--- Recently opened files in the current folder (or anywhere, if there are none here yet)
local function recent_items()
  local cwd = vim.fn.getcwd()
  local function collect(only_cwd)
    local files = {}
    for _, file in ipairs(vim.v.oldfiles) do
      if #files >= 6 then break end
      if vim.fn.filereadable(file) == 1 and (not only_cwd or vim.startswith(file, cwd .. '/')) then table.insert(files, file) end
    end
    return files
  end

  local files = collect(true)
  if #files == 0 then files = collect(false) end
  if #files == 0 then return { { name = 'No recent files yet', action = '', section = 'Recent' } } end

  local items = {}
  for i, file in ipairs(files) do
    local icon, icon_hl = '', nil
    if vim.g.have_nerd_font and _G.MiniIcons then
      icon, icon_hl = MiniIcons.get('file', file)
    end
    local dir = vim.fn.fnamemodify(file, ':.:~:h')
    table.insert(items, {
      key = tostring(i),
      icon = icon,
      icon_hl = icon_hl,
      name = vim.fn.fnamemodify(file, ':t'),
      hint = dir == '.' and '' or dir,
      section = 'Recent',
      action = function() edit(file) end,
    })
  end
  return items
end

-- [[ Layout ]]

local function unit(string, hl, type) return { string = string, hl = hl, type = type or 'decoration' } end
local function empty_line() return { unit('', nil, 'empty') } end

local function line_width(line)
  local width = 0
  for _, u in ipairs(line) do
    width = width + vim.fn.strdisplaywidth(u.string)
  end
  return width
end

--- Shortens `text` to `max` columns by cutting its start, e.g. `…/components/button`
local function truncate(text, max)
  if vim.fn.strdisplaywidth(text) <= max then return text end
  return '…' .. vim.fn.strcharpart(text, vim.fn.strchars(text) - max + 1)
end

local function git_branch(dir)
  local root = vim.fs.root(dir, '.git')
  if not root then return nil end

  local git_dir = root .. '/.git'
  local function read_line(path)
    local file = io.open(path, 'r')
    if not file then return nil end
    local line = file:read '*l'
    file:close()
    return line
  end

  -- In worktrees and submodules, `.git` is a file pointing to the real git directory
  if vim.fn.isdirectory(git_dir) == 0 then
    local target = (read_line(git_dir) or ''):match '^gitdir: (.+)$'
    if not target then return nil end
    git_dir = vim.startswith(target, '/') and target or (root .. '/' .. target)
  end

  local head = read_line(git_dir .. '/HEAD')
  if not head then return nil end
  return head:match '^ref: refs/heads/(.+)$' or head:sub(1, 7)
end

local function header_lines(show_logo)
  local lines = {}
  if show_logo then
    for i, text in ipairs(logo) do
      table.insert(lines, { unit(text, 'StarterLogo' .. i, 'header') })
    end
    table.insert(lines, empty_line())
  end

  local hour = tonumber(os.date '%H')
  local part_of_day = (hour < 4 and 'malam') or (hour < 11 and 'pagi') or (hour < 15 and 'siang') or (hour < 18 and 'sore') or 'malam'
  local user = vim.uv.os_get_passwd().username
  table.insert(lines, { unit(('Selamat %s, %s'):format(part_of_day, user), 'StarterGreeting', 'header') })

  local cwd = vim.fn.getcwd()
  local project = cwd == vim.env.HOME and '~' or vim.fn.fnamemodify(cwd, ':t')
  local project_line = { unit(icons.folder .. ' ', 'StarterIcon'), unit(project, 'StarterHint') }
  local branch = git_branch(cwd)
  if branch then vim.list_extend(project_line, { unit('  ·  ', 'StarterHint'), unit(icons.git_branch .. ' ', 'StarterIcon'), unit(branch, 'StarterHint') }) end
  table.insert(lines, project_line)

  return lines
end

local function footer_lines()
  local plugins = #vim.tbl_filter(function(p) return p.active end, vim.pack.get())
  local v = vim.version()
  return {
    { unit(icons.lightbulb .. '  ', 'StarterIcon'), unit(tip, 'StarterTip') },
    { unit(('↑↓ pilih  ·  Enter buka  ·  %d plugin  ·  Neovim %d.%d.%d'):format(plugins, v.major, v.minor, v.patch), 'StarterHint') },
  }
end

--- Turns an item into a line: [key]  [icon]  [name] ........ [hint]
local function item_parts(item_unit)
  local item = item_unit.item
  local left = { unit(' ' .. (item.key or ' ') .. ' ', item.key and 'StarterKey'), unit '  ' }
  if item.icon and item.icon ~= '' then vim.list_extend(left, { unit(item.icon, item.icon_hl or 'StarterIcon'), unit '  ' }) end
  item_unit.string = truncate(item_unit.string, 24)
  return left, item_unit, unit(truncate(item.hint or '', 20), 'StarterHint')
end

--- Content hook that replaces mini.starter's default layout with our own
local function layout(content, buf_id)
  -- Gather the items of each section, in order
  local sections = {}
  for _, line in ipairs(content) do
    for _, u in ipairs(line) do
      if u.type == 'item' then
        local section = sections[#sections]
        if not section or section.name ~= u.item.section then
          section = { name = u.item.section, units = {} }
          table.insert(sections, section)
        end
        table.insert(section.units, u)
      end
    end
  end

  -- Fit everything in the window: hide the logo and show fewer recent files if needed
  local win_id = vim.fn.bufwinid(buf_id)
  local height = win_id > 0 and vim.api.nvim_win_get_height(win_id) or vim.o.lines
  local recent = sections[2] and sections[2].units or {}
  local function total_lines(show_logo, n_recent)
    local n = (show_logo and #logo + 1 or 0) + 2 + 1 -- header + empty line
    n = n + 1 + #sections[1].units -- "Start" section
    if n_recent > 0 then n = n + 2 + n_recent end -- empty line + "Recent" section
    return n + 1 + 2 -- empty line + footer
  end
  local show_logo = height >= total_lines(true, math.min(#recent, 3)) + 2
  local n_recent = math.max(math.min(#recent, height - total_lines(show_logo, 0) - 2), 0)
  if sections[2] then
    for i = #recent, n_recent + 1, -1 do
      table.remove(recent, i)
    end
  end

  -- Build the item lines, with the hints aligned to the right
  local body, body_width = {}, 0
  for _, section in ipairs(sections) do
    for _, u in ipairs(section.units) do
      local left, item_unit, hint = item_parts(u)
      u._parts = { left = left, hint = hint }
      body_width = math.max(body_width, line_width(left) + line_width { item_unit } + 3 + line_width { hint })
    end
  end
  for i, section in ipairs(sections) do
    if #section.units > 0 then
      if i > 1 then table.insert(body, empty_line()) end
      table.insert(body, { unit(section.name, 'MiniStarterSection', 'section') })
      for _, u in ipairs(section.units) do
        local left, hint = u._parts.left, u._parts.hint
        local gap = body_width - line_width(left) - line_width { u } - line_width { hint }
        local line = vim.list_extend(vim.deepcopy(left), { u, unit(string.rep(' ', gap)), hint })
        table.insert(body, line)
      end
    end
  end

  -- Center the header and footer, and the body as a single block
  local header, footer = header_lines(show_logo), footer_lines()
  local width = body_width
  for _, line in ipairs(vim.list_extend(vim.list_extend({}, header), footer)) do
    width = math.max(width, line_width(line))
  end
  local function centered(line, line_w)
    local pad = math.floor((width - (line_w or line_width(line))) / 2)
    if pad > 0 and line[1].type ~= 'empty' then table.insert(line, 1, unit(string.rep(' ', pad))) end
    return line
  end

  local result = {}
  for _, line in ipairs(header) do
    table.insert(result, centered(line))
  end
  table.insert(result, empty_line())
  for _, line in ipairs(body) do
    table.insert(result, centered(line, body_width))
  end
  table.insert(result, empty_line())
  for _, line in ipairs(footer) do
    table.insert(result, centered(line))
  end
  return result
end

starter.setup {
  items = { start_items, recent_items },
  header = '',
  footer = '',
  -- Items are chosen with the keys shown next to them instead of by typing their name
  query_updaters = '',
  content_hooks = { layout, starter.gen_hook.aligning('center', 'center') },
}

-- [[ Colors ]]
-- Derived from the current colorscheme, so they also fit other themes (light or dark)

--- Mixes two colors: `amount` 0 gives `a`, 1 gives `b`
local function blend(a, b, amount)
  local function channel(color, shift) return math.floor(color / shift) % 256 end
  local result = 0
  for _, shift in ipairs { 65536, 256, 1 } do
    result = result + math.floor(channel(a, shift) * (1 - amount) + channel(b, shift) * amount + 0.5) * shift
  end
  return result
end

local function set_highlights()
  local function get(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
  local is_dark = vim.o.background == 'dark'
  local fg = get('Normal').fg or (is_dark and 0xD4D4D4 or 0x1F1F1F)
  local bg = get('Normal').bg or (is_dark and 0x1F1F1F or 0xFFFFFF)
  local accent = get('Directory').fg or 0x569CD6
  local accent_2 = get('Type').fg or accent
  local dimmed = blend(fg, bg, 0.45)

  local set = vim.api.nvim_set_hl
  for i = 1, #logo do
    set(0, 'StarterLogo' .. i, { fg = blend(accent, accent_2, (i - 1) / (#logo - 1)) })
  end
  set(0, 'StarterGreeting', { fg = fg, bold = true })
  set(0, 'StarterHint', { fg = dimmed })
  set(0, 'StarterTip', { fg = dimmed, italic = true })
  set(0, 'StarterIcon', { fg = accent })
  set(0, 'StarterKey', { fg = accent, bg = blend(bg, accent, 0.15), bold = true })
  set(0, 'MiniStarterSection', { fg = fg, bold = true })
  set(0, 'MiniStarterItem', { fg = fg })
  set(0, 'MiniStarterItemPrefix', { link = 'MiniStarterItem' })
  set(0, 'MiniStarterCurrent', { bg = get('Visual').bg or blend(bg, accent, 0.3) })
  set(0, 'MiniStarterInactive', { link = 'StarterHint' })
end
set_highlights()

local group = vim.api.nvim_create_augroup('custom-welcome', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', { group = group, callback = set_highlights })

-- [[ Keys ]]
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniStarterOpened',
  group = group,
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local function map(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = buf, nowait = true, desc = desc }) end

    local function run(item)
      if type(item.action) == 'string' then
        vim.cmd(item.action)
      else
        item.action()
      end
    end
    local function find_item(predicate)
      for _, item in ipairs(MiniStarter.content_to_items(MiniStarter.get_content(buf))) do
        if item.action ~= '' and predicate(item) then return item end
      end
    end

    -- The key shown next to each item runs it
    local keys = vim.tbl_map(function(item) return item.key end, start_items)
    for i = 1, 9 do
      table.insert(keys, tostring(i))
    end
    for _, key in ipairs(keys) do
      map(key, function()
        local item = find_item(function(item) return item.key == key end)
        if item then run(item) end
      end, 'Welcome: run item ' .. key)
    end

    -- Click an item to run it
    map('<LeftRelease>', function()
      local mouse = vim.fn.getmousepos()
      if mouse.winid ~= vim.api.nvim_get_current_win() then return end
      local item = find_item(function(item) return item._line == mouse.line - 1 end)
      if item then run(item) end
    end, 'Welcome: run clicked item')

    map('j', function() MiniStarter.update_current_item 'next' end, 'Welcome: next item')
    map('k', function() MiniStarter.update_current_item 'prev' end, 'Welcome: previous item')

    -- mini.starter uses Ctrl+P/Ctrl+N to move between items, bring back the VS Code shortcuts
    map('<C-p>', function() require('telescope.builtin').find_files() end, 'Go to file (Quick Open)')
    map('<C-n>', '<Cmd>enew<CR>', 'New file')
  end,
})
