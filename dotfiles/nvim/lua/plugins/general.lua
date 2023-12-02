return {
  -- Git
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Sudo
  'lambdalisue/suda.vim',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim',         opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = {}, -- treesitter interferes with VimTex
      },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end
  },

  {
    'mbbill/undotree',
  },
  {
    'theprimeagen/harpoon',
    opts = {
      tabline = true,
    }
  },
  -- 'mg979/vim-visual-multi'
  'folke/neodev.nvim',
  {
    dir = '/home/sbancuz/dev/neovim-multi-cursors',
    dev = true,
    dependencies = { 'Iron-E/nvim-libmodal' },
  },
}
