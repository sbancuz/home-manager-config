local wk = require('which-key')
local tb = require('telescope.builtin')
local map = vim.keymap.set
local mark = require('harpoon.mark')
local hp = require('harpoon.ui')

vim.api.nvim_create_user_command('W', function() vim.cmd(':SudaWrite') end, {})

wk.register({
  n = { vim.cmd.Ex, '[N]etrw' },
  g = { vim.cmd.Git, '[G]it' },
  f = {
    name = '[F]ind',
    f = { tb.git_files, 'git [F]iles' },
    t = { tb.current_buffer_fuzzy_find, '[T]ext' },
    r = { tb.oldfiles, '[R]ecently opened files' },
    g = { tb.live_grep, '[G]rep' },
    w = { tb.grep_string, '[W]ord' },
    d = { tb.diagnostics, '[D]iagnostics' },
    a = { tb.find_files, '[A]ll files' },
    h = { tb.help_tags, '[H]elp tags' },
  },
  h = {
    a = { mark.add_file, '[A]dd file' },
    m = { hp.toggle_quick_menu, '[M]enu' },
  },
  u = { vim.cmd.UndotreeToggle, '[U]ndo tree' },
}, { prefix = '<leader>' })

map('n', 'h1', function() hp.nav_file(1) end)
map('n', 'h2', function() hp.nav_file(2) end)
map('n', 'h3', function() hp.nav_file(3) end)
map('n', 'h4', function() hp.nav_file(4) end)

-- Move lines
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Append line below but cursor remains in place
map("n", "J", "mzJ`z")

-- Half page jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Search but cursor stays in the middle
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste with void buffer
map('x', '<leader>p', '\"_dP', { desc = 'which_key_ignore' })

-- Synchronize with system clipboard
-- This requires wl-clipboard installed on wayland
map({ "n", "v" }, "<leader>y", [["+y]], { desc = 'which_key_ignore' })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = 'which_key_ignore' })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = 'which_key_ignore' })
map("n", "<leader>Y", [["+Y]], { desc = 'which_key_ignore' })

-- Search and replace
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[S]earch and replace word' })
map("v", "<leader>s", [[y:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]], { desc = '[S]earch and replace selection' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local lsp_attach = function(_, bufnr)
  local lbuf = vim.lsp.buf

  -- Gotos
  wk.register({
    d = { lbuf.definition, 'Goto [D]efinition' },
    D = { lbuf.declaration, 'Goto [D]eclaration' },
    r = { lbuf.references, 'Goto [R]eferences' },
    i = { lbuf.implementation, 'Goto [I]mplementation' },
  }, { prefix = 'g' })

  -- Code actions
  wk.register({
    a = { lbuf.code_action, 'Code [A]ctions' },
    r = { lbuf.rename, '[R]ename' },
  }, { prefix = 'c' })

  wk.register({
    w = {
      name = '[W]orkspace',
      a = { lbuf.add_workspace_folder, '[A]dd forlder' },
      r = { lbuf.remove_workspace_folder, '[R]emove folder' },
      l = { function()
        print(vim.inspect(lbuf.list_workspace_folders()))
      end, '[L]ist forlders' },
      s = { tb.lsp_dynamic_workspace_symbols, '[S]ymbols' },
    },
    b = {
      name = '[B]uffer',
      s = { tb.lsp_document_symbols, '[S]ymbols' },
    },
  }, { prefix = '<leader>' })

  -- See `:help K` for why this keymap
  -- somehow it is built in a way that makes it impossible to change
  -- map('n', 'K', vim.lsp.buf.hover, { bufnr, 'Hover Documentation' })
  -- map('n', '<C-k>', vim.lsp.buf.signature_help, { bufnr, 'Signature Documentation' })
end

require('gitsigns').on_attach = function(bufnr)
  map('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
  map('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
  map('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
end

-- vim.api.nvim_add_user_command('W', vim.cmd.SudaWrite)
local get_cmp_maps = function()
  local cmp = require('cmp')
  return cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }
end

return {
  lsp_attach = lsp_attach,
  get_cmp_maps = get_cmp_maps,
}
