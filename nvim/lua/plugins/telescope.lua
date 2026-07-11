return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
        if vim.fn.executable("rg") == 1 then
            return {}
        end

        -- no ripgrep on PATH, fall back to grep/find
        return {
            defaults = {
                vimgrep_arguments = {
                    "grep",
                    "--color=never",
                    "--line-number",
                    "--with-filename",
                    "--ignore-case",
                    "--recursive",
                },
            },
            pickers = {
                find_files = {
                    find_command = { "find", ".", "-type", "f", "-not", "-path", "*/.git/*" },
                },
            },
        }
    end,
}
