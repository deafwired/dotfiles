return {
  "m4xshen/autoclose.nvim",
  opts = function(_, opts)
    opts.keys = opts.keys or {}

    opts.keys["'"] = vim.tbl_extend("force",
      opts.keys["'"] or {},
      {
        disable_filetypes = { "racket" },
      }
    )

    return opts
  end,
}
