return {
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    -- config = function(_, _)
    --   local capabilities = vim.lsp.protocol.make_client_capabilities()
    --   capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    --   local opts = {
    --     server = {
    --       on_attach = require('keymaps').lsp_attach,
    --       capabilities = capabilities,
    --     }
    --   }
    --
    --   require('rust-tools').setup(opts)
    -- end
  },
  {
    'saecki/crates.nvim',
    dependencies = 'hrsh7th/nvim-cmp',
    ft = { "toml" },
    config = function(_, opts)
      local crates = require('crates')
      crates.setup(opts)
      require('cmp').setup.buffer({
        sources = { { name = "crates" } }
      })
      crates.show()
      -- require("core.utils").load_mappings("crates")
    end,
  },
}
