-- local harpoon = require("harpoon")
-- harpoon:setup()

-- Save
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { silent = true })

-- Move line up
vim.keymap.set("n", "<A-Up>", ":<C-u>move-2<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-Up>", "<Esc>:move-2<CR>a", { noremap = true, silent = true })

-- Move line down
vim.keymap.set("n", "<A-Down>", ":<C-u>move+<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-Down>", "<Esc>:move+<CR>a", { noremap = true, silent = true })

-- Escape searching
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

-- Escape terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Move in tiles
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

--- PLUGIN KEYBINDS ---
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    callback = function(event)
        vim.keymap.set("n", "q", "<CMD>close<CR>", {buffer = event.buf, silent = true})
    end,
})

vim.keymap.set("n", "<M-a>", function() harpoon:list():add() end)
vim.keymap.set("n", "<M-1>", function() harpoon:list():select(1) end)
