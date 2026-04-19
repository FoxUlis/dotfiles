local M = {}

M.setup = function()
	-- Новый способ настройки LSP через vim.lsp.config (Neovim 0.10+)
	-- Вместо require('lspconfig').lua_ls.setup(...) используем:

	vim.lsp.config.lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { 'vim' }
				}
			}
		}
	}

	-- Для остальных серверов (pyright, clangd) настройки по умолчанию,
	-- так как они управляются через mason-lspconfig

	-- === KEYMAPS ===
	local opts = { noremap = true, silent = true }
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
end

return M
