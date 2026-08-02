return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.sourcekit = {
        root_markers = {
          { "Package.swift", "compile_commands.json" },
          ".git",
        },
      }
      opts.externally_managed_servers.sourcekit = true
      table.insert(opts.manually_enabled_servers, "sourcekit")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        swift = { "swiftformat" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "swift")
      table.insert(opts.highlight_filetypes, "swift")
      table.insert(opts.indent_filetypes, "swift")
    end,
  },
}
