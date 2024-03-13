return {
    "laytan/cloak.nvim",
    config = function()
        require("cloak").setup({
            cloak_character = "█",
            cloak_length = 5,
        })
        vim.api.nvim_set_keymap("n", "<leader>ct", ":CloakToggle<CR>", { noremap = true, silent = true })
    end
}
