local T = {}

T.nixfix = function()
  local mason_registry = require("mason-registry")
  mason_registry:on("package:install:success", function(pkg)
    pkg:get_receipt():if_present(function(receipt)
      -- Figure out the interpreter inspecting nvim itself
      -- This is the same for all packages, so compute only once
      local interpreter = os.execute(
        ("patchelf --print-interpreter %q"):format(
          "$(grep -oE '\\/nix\\/store\\/[a-z0-9]+-neovim-unwrapped-[0-9]+\\.[0-9]+\\.[0-9]+\\/bin\\/nvim' $(which nvim))"
        )
      )

      for _, rel_path in pairs(receipt.links.bin) do
        local bin_abs_path = pkg:get_install_path() .. "/" .. rel_path
        if pkg.name == "lua-language-server" then
          bin_abs_path = pkg:get_install_path() .. "/extension/server/bin/lua-language-server"
        end

        -- Set the interpreter on the binary
        os.execute(
          ("patchelf --set-interpreter %q %q"):format(interpreter, bin_abs_path)
        )
      end
    end)
  end)
end

T.toggleFormatOnSave = function(format_is_enabled)
  vim.api.nvim_create_user_command('ToggleFormat', function()
    format_is_enabled = not format_is_enabled
    print('Setting autoformatting to: ' .. tostring(format_is_enabled))
  end, {})

  -- Create an augroup that is used for managing our formatting autocmds.
  --      We need one augroup per client to make sure that multiple clients
  --      can attach to the same buffer without interfering with each other.
  local _augroups = {}
  local get_augroup = function(client)
    if not _augroups[client.id] then
      local group_name = 'kickstart-lsp-format-' .. client.name
      local id = vim.api.nvim_create_augroup(group_name, { clear = true })
      _augroups[client.id] = id
    end

    return _augroups[client.id]
  end

  -- Whenever an LSP attaches to a buffer, we will run this function.
  --
  -- See `:help LspAttach` for more information about this autocmd event.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
    -- This is where we attach the autoformatting for reasonable clients
    callback = function(args)
      local client_id = args.data.client_id
      local client = vim.lsp.get_client_by_id(client_id)
      local bufnr = args.buf

      -- Only attach to clients that support document formatting
      if not client.server_capabilities.documentFormattingProvider then
        return
      end

      -- Tsserver usually works poorly. Sorry you work with bad languages
      -- You can remove this line if you know what you're doing :)
      if client.name == 'tsserver' then
        return
      end

      -- Create an autocmd that will run *before* we save the buffer.
      --  Run the formatting command for the LSP that has just attached.
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = get_augroup(client),
        buffer = bufnr,
        callback = function()
          if not format_is_enabled then
            return
          end

          vim.lsp.buf.format {
            async = false,
            filter = function(c)
              return c.id == client.id
            end,
          }
        end,
      })
    end,
  })
end

return T
