return {
    "alexanderbluhm/black.nvim",
    name = "black",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme"black"
    end
}
