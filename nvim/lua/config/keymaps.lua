vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opts = { noremap = true, silent = true }

-- === Clipboard ===
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", "\"+p", { desc = "Paste from system clipboard" })
