return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>b", group = "[b]uffers" },
        { "<leader>c", group = "[c]ode" },
        { "<leader>d", group = "[d]ebug" },
        { "<leader>f", group = "[f]ind / format" },
        { "<leader>g", group = "[g]it" },
        { "<leader>gh", group = "git [h]unks" },
        { "<leader>gt", group = "git [t]oggles" },
        { "<leader>l", group = "[l]sp" },
        { "<leader>m", group = "[m]arkdown / SQL" },
        { "<leader>n", group = "[n]ode packages / notifications" },
        { "<leader>o", group = "[o]pen / run / OS" },
        { "<leader>s", group = "[s]earch" },
        { "<leader>t", group = "[t]ests" },
        { "<leader>u", group = "[u]I toggles" },
      },
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
  },
}
