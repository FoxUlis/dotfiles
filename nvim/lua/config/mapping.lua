vim.g.mapleader = " "

vim.keymap.set({"n", "v"}, "<leader>p", "\"+p")
vim.keymap.set({"n", "v"}, "<leader>y", "\"+y")
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

--Neotree
vim.keymap.set("n", "<leader>E", ":Neotree float reveal<CR>")

--Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

--ToggleTerm
vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<CR>')

-- LSP

-- Перейти к определению
map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: Go to Definition" }))

-- Найти ссылки
map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP: Find References" }))

-- Показать документацию (hover)
map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: Hover Documentation" }))

-- Переименовать символ
map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: Rename Symbol" }))

-- Кодовые действия (quick fix, import organization)
map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: Code Action" }))

-- Форматирование файла
map("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, vim.tbl_extend("force", opts, { desc = "LSP: Format Buffer" }))

-- Показать диагностические ошибки под курсором
map("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "LSP: Line Diagnostics" }))

-- Переход к следующей/предыдущей ошибке
map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "LSP: Prev Diagnostic" }))
map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "LSP: Next Diagnostic" }))

-- === Опционально: Авто-форматирование при сохранении ===
-- Создай группу автокоманд, если её нет
vim.api.nvim_create_augroup("LspFormatting", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = "LspFormatting",
  callback = function()
    -- Форматируем только если есть активный LSP с поддержкой форматирования
    if vim.lsp.buf.format then
      vim.lsp.buf.format({ async = false })
    end
  end,
})
