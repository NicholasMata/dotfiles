return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    config = function() -- This is the function that runs, AFTER loading
      local wk = require("which-key")
      wk.setup()

      -- Declare leader groups (no rhs)
      wk.add({
        { "<leader>m", group = "[m]arkdown" },
        { "<leader>mp", group = "[p]review" },
        { "<leader>l", group = "[l]sp" },
        { "<leader>d", group = "[d]ebug" },
        { "<leader>t", group = "[t]ests" },
        { "<leader>g", group = "[g]it" },
        { "<leader>o", group = "[o]pen / run" },
      }, { mode = "n" })
    end,
  },
}
