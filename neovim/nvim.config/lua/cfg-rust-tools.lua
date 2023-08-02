local function on_attach(client, buffer)
  -- This callback is called when the LSP is atttached/enabled for this buffer
  -- we could set keymaps related to LSP, etc here.
  local keymap_opts = { buffer = buffer }
  -- Code navigation and shortcuts
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, keymap_opts)
  vim.keymap.set('n', '<c-k>', vim.lsp.buf.signature_help, keymap_opts)
  vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, keymap_opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, keymap_opts)
  vim.keymap.set('n', 'g0', vim.lsp.buf.document_symbol, keymap_opts)
  vim.keymap.set('n', 'gW', vim.lsp.buf.workspace_symbol, keymap_opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, keymap_opts)
  vim.keymap.set('n', 'ga', vim.lsp.buf.code_action, keymap_opts)

  -- Show diagnostic popup on cursor hover
  local diag_float_grp = vim.api.nvim_create_augroup('DiagnosticFloat', { clear = true })
  vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
      vim.diagnostic.open_float(nil, { focusable = false })
    end,
    group = diag_float_grp,
  })

  -- Goto previous/next diagnostic warning/error
  vim.keymap.set('n', 'gj', vim.diagnostic.goto_prev, keymap_opts)
  vim.keymap.set('n', 'gk', vim.diagnostic.goto_next, keymap_opts)

  local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
      vim.lsp.buf.format({ timeout_ms = 200 })
    end,
    group = format_sync_grp,
  })
end

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
require('rust-tools').setup {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = false,
      parameter_hints_prefix = '',
      other_hints_prefix = '',
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = on_attach,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ['rust-analyzer'] = {
        -- enable clippy on save
        checkOnSave = {
          command = 'clippy',
        },
        rustfmt = {
          enableRangeFormatting = true,
        },
        cargo = {
          runBuildScripts = true,
        },
        procMacro = {
          enable = true,
          attributes = {
            enable = true,
          },
        }
      },
    },
  },
}
