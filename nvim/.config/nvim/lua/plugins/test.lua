return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {},
    },
    config = function(_, opts)
      local adapters = {}
      for _, factory in pairs(opts.adapters) do
        table.insert(adapters, factory())
      end

      require("neotest").setup(vim.tbl_extend("force", opts, { adapters = adapters }))
    end,
    keys = {
      {
        "<leader>ta",
        function()
          require("neotest").run.run({ suite = true })
        end,
        desc = "run [a]ll tests",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "[r]un nearest test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "run test [f]ile",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "run [l]ast test",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "[d]ebug nearest test",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "toggle test [s]ummary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
        desc = "show test [o]utput",
      },
      {
        "<leader>tp",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "toggle output [p]anel",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle()
        end,
        desc = "toggle test [w]atch",
      },
      {
        "<leader>tx",
        function()
          require("neotest").run.stop()
        end,
        desc = "stop nearest test",
      },
    },
  },
}
