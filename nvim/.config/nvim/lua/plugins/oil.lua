return {
  "stevearc/oil.nvim",
  lazy = false,
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
  },
  keys = {
    {
      "<leader>e",
      "<cmd>Oil<cr>",
      desc = "[e]xplorer",
    },
    {
      "<leader>oi",
      function()
        local oil = require("oil")

        -- Track icon state globally
        vim.g.oil_icons_enabled = not vim.g.oil_icons_enabled

        if vim.g.oil_icons_enabled then
          oil.set_columns({ "icon" })
        else
          oil.set_columns({})
        end
      end,
      desc = "Oil: Toggle filetype icons",
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
