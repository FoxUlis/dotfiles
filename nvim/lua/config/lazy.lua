-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- Setup lazy.nvim
require("lazy").setup({

	spec = {

		--------------------------------------------------------------------------------------
		{
			'nvim-telescope/telescope.nvim',
			version = "*",
			dependencies = {
				'nvim-lua/plenary.nvim',
			},
			config = function()
				require('telescope').setup()
			end
		},
		--------------------------------------------------------------------------------------
		-- Mason Manager
		{
			"mason-org/mason.nvim",
			opts = {}, -- Использует дефолтные настройки
			config = function()
				require("mason").setup({
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				})
			end
		},
		--------------------------------------------------------------------------------------
		-- LSP Configurator (ГЛАВНЫЙ ПЛАГИН)
		{
			"neovim/nvim-lspconfig",
			lazy = false, -- ВАЖНО: Загружать сразу, чтобы работала :LspInfo
			dependencies = {
				"mason-org/mason.nvim",
				"mason-org/mason-lspconfig.nvim",
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				-- 1. Настраиваем связку Mason и LSP
				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls", "pyright", "clangd", "ts_ls" },
					automatic_installation = true,
				})

				-- 2. Вызываем твой отдельный файл конфигурации (где кейбиндинги и детали)
				-- Убедись, что файл лежит по пути lua/config/lsp.lua
				local ok, lsp_config = pcall(require, "config.lsp")
				if ok then
					lsp_config.setup()
				else
					print("Warning: config.lsp not found or has errors")
				end
			end,
		},
		--------------------------------------------------------------------------------------
		-- Autocompletion (CMP)
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter", -- Загружать только когда начинаешь печатать
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
			},
			config = function()
				local cmp = require('cmp')
				cmp.setup({
					sources = cmp.config.sources({
						{ name = 'nvim_lsp' },
						{ name = 'buffer' },
						{ name = 'path' },
					}),
					mapping = cmp.mapping.preset.insert({
						['<C-b>'] = cmp.mapping.scroll_docs(-4),
						['<C-f>'] = cmp.mapping.scroll_docs(4),
						['<C-Space>'] = cmp.mapping.complete(),
						['<C-e>'] = cmp.mapping.abort(),
						['<CR>'] = cmp.mapping.confirm({ select = true }),
					}),
				})
			end
		},
		--------------------------------------------------------------------------------------
		{
			'akinsho/toggleterm.nvim',
			version = '*',
			config = true
		},
		--------------------------------------------------------------------------------------
		{
			"nvim-neo-tree/neo-tree.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"MunifTanjim/nui.nvim",
				"nvim-tree/nvim-web-devicons",
			},
			lazy = false,
			config = function()
				require("neo-tree").setup({
					close_if_last_window = false, -- Закрывать Neo-tree, если это последнее окно
					popup_border_style = "rounded",
					enable_git_status = true,
					enable_diagnostics = true,
				})
			end
		},
		--------------------------------------------------------------------------------------
		{
			"nvim-lualine/lualine.nvim",
			config = function()
				require('lualine').setup()
			end
		},
		--------------------------------------------------------------------------------------
		{
			"nvim-tree/nvim-web-devicons",
			config = function()
				require("nvim-web-devicons").setup()
			end
		},
		--------------------------------------------------------------------------------------
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("tokyonight")
			end
		},
		--------------------------------------------------------------------------------------
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true
		},
		--------------------------------------------------------------------------------------
		{
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup()
			end
		},
		--------------------------------------------------------------------------------------
	},

	checker = { enable = true },
})
