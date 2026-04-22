-- lua/plugins/lsp-config.lua

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"folke/neodev.nvim",
		},
		config = function()
			-- 1. Диагностика
			vim.diagnostic.config({
				virtual_text = { prefix = "●", spacing = 4 },
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- 2. Mason Setup (Только установка бинарников)
			require("mason").setup({
				ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } },
			})

			require("mason-lspconfig").setup({
				ensure_installed = { "clangd", "pyright", "lua_ls", "ts_ls" },
				automatic_installation = true,
			})

			-- 3. Настройка серверов через vim.lsp.config (Новый API Neovim 0.11+)
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- === Lua LS ===
			vim.lsp.config.lua_ls = {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true) },
					},
				},
			}

			-- === Clangd ===
			vim.lsp.config.clangd = {
				capabilities = capabilities,
				cmd = {
					"clangd",
					"--background-index",
					"--header-insertion=iwyu",
				},
				init_options = {
					inlayHints = {
						enabled = true,
						parameterNames = true,
						deducedTypes = true,
					}
				}
			}

			-- === Pyright ===
			vim.lsp.config.pyright = {
				capabilities = capabilities,
			}

			-- === TS_LS ===
			vim.lsp.config.ts_ls = {
				capabilities = capabilities,
			}

			-- 4. Автоматический запуск серверов при открытии файла
			-- Этот хук говорит Neovim: "Если для этого типа файла есть конфиг в vim.lsp.config, запусти его"
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("LspAutoStart", { clear = true }),
				callback = function(args)
					local server_name = nil
					if args.match == "lua" then
						server_name = "lua_ls"
					elseif args.match == "c" or args.match == "cpp" then
						server_name = "clangd"
					elseif args.match == "python" then
						server_name = "pyright"
					elseif args.match == "typescript" or args.match == "javascript" then
						server_name = "ts_ls"
					end

					if server_name and vim.lsp.config[server_name] then
						-- Проверяем, не запущен ли уже сервер для этого буфера
						local clients = vim.lsp.get_clients({ bufnr = args.buf })
						local has_server = false
						for _, client in ipairs(clients) do
							if client.name == server_name then
								has_server = true
								break
							end
						end

						if not has_server then
							vim.lsp.start(vim.lsp.config[server_name])
						end
					end
				end,
			})

			-- 5. Маппинги LSP (Те же самые, работают независимо от способа запуска)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, noremap = true, silent = true }

					vim.keymap.set("n", "gd", vim.lsp.buf.definition,
						vim.tbl_extend("force", opts, { desc = "LSP: Go to Definition" }))
					vim.keymap.set("n", "gr", vim.lsp.buf.references,
						vim.tbl_extend("force", opts, { desc = "LSP: Find References" }))
					vim.keymap.set("n", "K", vim.lsp.buf.hover,
						vim.tbl_extend("force", opts, { desc = "LSP: Hover Documentation" }))

					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
						vim.tbl_extend("force", opts, { desc = "LSP: Rename Symbol" }))
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "LSP: Code Action" }))
					vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end,
						vim.tbl_extend("force", opts, { desc = "LSP: Format Buffer" }))

					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
						vim.tbl_extend("force", opts, { desc = "LSP: Prev Diagnostic" }))
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
						vim.tbl_extend("force", opts, { desc = "LSP: Next Diagnostic" }))
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float,
						vim.tbl_extend("force", opts, { desc = "LSP: Line Diagnostics" }))
				end,
			})

			-- 6. Автоформатирование
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
				callback = function()
					if vim.lsp.buf.format then
						vim.lsp.buf.format({ async = false })
					end
				end,
			})
		end,
	},

	-- === CMP и Autopairs остаются без изменений ===
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')
			cmp.setup({
				snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
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
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
}
