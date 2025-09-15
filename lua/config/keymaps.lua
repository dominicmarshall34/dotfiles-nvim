-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Keep cursor centered
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Better yank
keymap("n", "<leader>yy", '"+y', { desc = "Yank to clipboard" })
keymap("v", "<leader>yy", '"+y', { desc = "Yank to clipboard" })
keymap("n", "<leader>yl", '"+Y', { desc = "Yank line to clipboard" })

-- Yank entire file to clipboard
keymap("n", "<leader>ya", 'gg"+yG', { desc = "Yank all to clipboard" })

-- Better paste
keymap("v", "p", '"_dP', opts)
