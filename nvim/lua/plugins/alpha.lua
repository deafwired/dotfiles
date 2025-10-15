return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local dashboard = require("alpha.themes.startify")

    dashboard.section.header.val = {
      [[                      /$$              ]],
      [[                     |__/              ]],
      [[ /$$$$$$$  /$$    /$$ /$$ /$$$$$$/$$$$ ]],
      [[| $$__  $$|  $$  /$$/| $$| $$_  $$_  $$]],
      [[| $$  \ $$ \  $$/$$/ | $$| $$ \ $$ \ $$]],
      [[| $$  | $$  \  $$$/  | $$| $$ | $$ | $$]],
      [[| $$  | $$   \  $/   | $$| $$ | $$ | $$]],
      [[|__/  |__/    \_/    |__/|__/ |__/ |__/]],
    }

    return dashboard.opts
  end,
}
