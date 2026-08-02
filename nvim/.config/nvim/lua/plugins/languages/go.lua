return {
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "delve")
    end,
  },
  {
    "leoluz/nvim-dap-go",
    opts = {
      delve = {
        -- On Windows Delve must be run attached or it crashes.
        detached = vim.fn.has("win32") == 0,
      },
    },
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
}
