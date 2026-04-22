-- lua/config/lazy.lua

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

-- Важно: mapleader должен быть установлен ДО загрузки lazy, если ты используешь его в маппингах плагинов
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		-- Автоматически загружает все файлы из lua/plugins/*.lua
		{ import = "plugins" },

		-- Если у тебя есть специфичные плагины, которые нельзя вынести в отдельный файл,
		-- можно добавить их сюда, но лучше держать всё в папке plugins/
	},
	defaults = {
		lazy = true,           -- По умолчанию все плагины ленивые
	},
	checker = { enabled = true }, -- Проверка обновлений
	ui = {
		border = "rounded",
	},
})
