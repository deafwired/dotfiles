return {
    "m4xshen/autoclose.nvim", opts = {
        keys = {
            ["'"] = {escape = true, close = true, pair = "''", disable_filetypes = { "rust" } }
        }
    }
}
