local harpoon = require("harpoon")

vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { silent = true })

vim.keymap.set("n", "<A-Up>", ":<C-u>move-2<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-Up>", "<Esc>:move-2<CR>a", { noremap = true, silent = true })

vim.keymap.set("n", "<A-Down>", ":<C-u>move+<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<A-Down>", "<Esc>:move+<CR>a", { noremap = true, silent = true })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("n", "<M-a>", function()
    harpoon:list():add()
end, { desc = "Harpoon add file" })

vim.keymap.set("n", "<M-d>", function()
    local list = harpoon:list()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(current_buf), ":p")
    
    local index = -1
    for i = 1, list:length() do
        local item = list:get(i)
        if item then
            local item_file = vim.fn.fnamemodify(item.value, ":p")
            if item_file == current_file then
                index = i
                break
            end
        end
    end
    
    if index == -1 then
        -- resort to default if can't find it
        list:remove()
        return
    end
    
    -- Collect all items after the deleted index
    local items_after = {}
    for i = index + 1, list:length() do
        local item = list:get(i)
        if item then
            table.insert(items_after, item)
        end
    end
    
    list:remove_at(index)
    
    for i, item in ipairs(items_after) do
        list:replace_at(index + i - 1, item)
    end
end, { desc = "Harpoon remove file (with shift)" })

vim.keymap.set("n", "<M-e>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon quick menu" })

vim.keymap.set("n", "<M-n>", function()
    harpoon:list():next()
end, { desc = "Harpoon next file" })

vim.keymap.set("n", "<M-p>", function()
    harpoon:list():prev()
end, { desc = "Harpoon previous file" })

vim.keymap.set("n", "<M-1>", function()
    harpoon:list():select(1)
end, { desc = "Harpoon file 1" })

vim.keymap.set("n", "<M-2>", function()
    harpoon:list():select(2)
end, { desc = "Harpoon file 2" })

vim.keymap.set("n", "<M-3>", function()
    harpoon:list():select(3)
end, { desc = "Harpoon file 3" })

vim.keymap.set("n", "<M-4>", function()
    harpoon:list():select(4)
end, { desc = "Harpoon file 4" })
