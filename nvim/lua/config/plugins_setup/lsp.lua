eturn M-- ~/.config/nvim/lua/config/lsp.lua

local M = {}

M.setup = function()
  local lspconfig = require("lspconfig")
  
  -- Глобальные настройки возможностей LSP (для cmp)
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- Настройка Lua LS (для самого Neovim)
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  })

  -- Остальные серверы (pyright, clangd) настроятся автоматически через mason-lspconfig,
  -- так как мы указали их в ensure_installed в init.lua.
  -- Если нужно настроить их индивидуально, раскомментируй ниже:
  
  -- lspconfig.pyright.setup({ capabilities = capabilities })
  -- lspconfig.clangd.setup({ capabilities = capabilities })

  -- === KEYMAPS ===
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
end

return M
