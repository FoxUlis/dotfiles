-- lua/plugins/core-ui.lua

return {
	-- === Тема ===
	{
		"folke/tokyonight.nvim",
		lazy = false, -- Загружаем сразу, чтобы не мигало при старте
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	-- === Иконки ===
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		opts = {},
	},

	-- === Статусная строка ===
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "tokyonight",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},

	-- === Файловый менеджер (Neo-tree) ===
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		keys = {
			-- Твой маппинг для плавающего окна
			{ "<leader>E", "<cmd>Neotree float reveal<cr>", desc = "NeoTree Float Reveal" },
			-- Стандартный тоггл боковой панели
			{ "<leader>e", "<cmd>Neotree toggle<cr>",       desc = "Toggle NeoTree" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			close_if_last_window = false,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
		},
	},

	-- === Поиск (Telescope) ===
	{
		'nvim-telescope/telescope.nvim',
		version = "*",
		dependencies = { 'nvim-lua/plenary.nvim' },
		cmd = 'Telescope',
		keys = {
			{ '<leader>ff', function() require('telescope.builtin').find_files() end, desc = 'Find Files' },
			{ '<leader>fg', function() require('telescope.builtin').live_grep() end,  desc = 'Live Grep' },
			{ '<leader>fb', function() require('telescope.builtin').buffers() end,    desc = 'Buffers' },
			{ '<leader>fh', function() require('telescope.builtin').help_tags() end,  desc = 'Help Tags' },
		},
		opts = {
			defaults = {
				vimgrep_arguments = {
					'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'
				},
			},
		},
	},

	-- === Терминал (ToggleTerm) ===
	{
		"akinsho/toggleterm.nvim",
		version = '*',
		cmd = "ToggleTerm",
		keys = {
			{ '<leader>tf', "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle Float Terminal" },
			{ '<c-\\>',     "<cmd>ToggleTerm<cr>",                 desc = "Toggle Terminal" },
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			-- Настройка маппингов внутри терминала (как было у тебя)
			function _G.set_terminal_keymaps()
				local t_opts = { buffer = 0 }
				vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], t_opts)
				vim.keymap.set('t', 'jk', [[<C-\><C-n>]], t_opts)
				vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], t_opts)
				vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], t_opts)
				vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], t_opts)
				vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], t_opts)
				vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], t_opts)
			end

			vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
		end,
		opts = {
			size = 20,
			open_mapping = [[<c-\>]],
			direction = "float",
			float_opts = {
				border = "curved",
			},
		},
	},

	-- === Подсказки клавиш (Which-Key) ===
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
}
