return {
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufReadPost package.json", "BufNewFile package.json" },
    opts = {
      autostart = false,
    },
    keys = {
      {
        "<leader>nt",
        function()
          require("package-info").toggle()
        end,
        ft = "json",
        desc = "Toggle Package Info",
      },
      {
        "<leader>nu",
        function()
          require("package-info").update()
        end,
        ft = "json",
        desc = "Update Package",
      },
      {
        "<leader>ni",
        function()
          require("package-info").install()
        end,
        ft = "json",
        desc = "Install Package",
      },
      {
        "<leader>nd",
        function()
          require("package-info").delete()
        end,
        ft = "json",
        desc = "Delete Package",
      },
      {
        "<leader>np",
        function()
          require("package-info").change_version()
        end,
        ft = "json",
        desc = "Change Package Version",
      },
    },
  },
}
