return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "[b]uffers", icon = { icon = "󰓩", color = "blue" } },
        { "<leader>c", group = "[c]ode", icon = { icon = "󰅩", color = "cyan" } },
        { "<leader>cf", group = "[f]ormat", icon = { icon = "󰉼", color = "purple" } },
        { "<leader>d", group = "[d]ebug", icon = { icon = "", color = "red" } },
        { "<leader>f", group = "[f]ind", icon = { icon = "󰍉", color = "green" } },
        { "<leader>g", group = "[g]it", icon = { icon = "󰊢", color = "orange" } },
        { "<leader>gh", group = "git [h]unks", icon = { icon = "󰊤", color = "orange" } },
        { "<leader>gt", group = "git [t]oggles", icon = { icon = "", color = "orange" } },
        { "<leader>l", group = "[l]sp", icon = { icon = "󰒋", color = "purple" } },
        { "<leader>n", group = "[n]ode packages", icon = { icon = "", color = "green" } },
        { "<leader>o", group = "[o]pen / run / OS", icon = { icon = "󰐊", color = "yellow" } },
        { "<leader>p", group = "[p]review", icon = { icon = "󰈈", color = "green" } },
        { "<leader>s", group = "[s]earch", icon = { icon = "", color = "cyan" } },
        { "<leader>t", group = "[t]ests", icon = { icon = "󰙨", color = "green" } },
        { "<leader>u", group = "[u]I toggles", icon = { icon = "󰙵", color = "yellow" } },
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
