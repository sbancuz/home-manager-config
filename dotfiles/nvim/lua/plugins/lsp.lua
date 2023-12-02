return {
  'neovim/nvim-lspconfig',
  {
    'williamboman/mason.nvim',
    config = true,
    -- setup = require('lua.plugins.lspconfig.mason').nixfix
  },
  'williamboman/mason-lspconfig.nvim',
  -- Status updates
  { 'j-hui/fidget.nvim', tag = 'legacy' },

  -- Some lua configs
  'folke/neodev.nvim',
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },

    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()
      luasnip.config.setup {}
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = require('keymaps').get_cmp_maps(),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'crates' },
        },
      }
    end
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.preset("recommended")
      lsp_zero.on_attach(require('keymaps').lsp_attach)

      require('mason').setup({})
      require('mason-lspconfig').setup({
        -- Replace the language servers listed here
        -- with the ones you want to install
        ensure_installed = { 'lua_ls', 'rust_analyzer', 'clangd' },
        handlers = {
          lsp_zero.default_setup,
          rust_analyzer = function()
            local rust_tools = require('rust-tools')
            rust_tools.setup({})
          end,
        },
      })
      -- Setup neovim lua configuration
      require('neodev').setup()
      lsp_zero.setup()

      -- Switch for controlling whether you want autoformatting.
      --  Use :ToggleFormat to toggle autoformatting on or off
      require('plugins.lspconfig.mason').toggleFormatOnSave(true);
    end
  },
  require('plugins.lspconfig.rust'),
}
