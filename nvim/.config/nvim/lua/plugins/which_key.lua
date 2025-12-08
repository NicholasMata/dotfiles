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
        { "m", group = "[m]arkdown" },
        { "mp", group = "[p]review" },
        { "l", group = "[l]sp" },
        { "d", group = "[d]ebug" },
        { "t", group = "[t]elescope" },
        { "g", group = "[g]it" },
        { "o", group = "[o]s" },
      }, { mode = "n", prefix = "<leader>" })
    end,
  },
}
