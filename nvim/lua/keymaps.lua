-- save
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { silent = true })

-- Move line up
vim.api.nvim_set_keymap("n", "<A-Up>", ":<C-u>move-2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-Up>", "<Esc>:move-2<CR>", { noremap = true, silent = true })

-- Move line down
vim.api.nvim_set_keymap("n", "<A-Down>", ":<C-u>move+<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-Down>", "<Esc>:move+<CR>", { noremap = true, silent = true })
