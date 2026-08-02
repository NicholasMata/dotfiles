return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.taplo = {}
      opts.externally_managed_servers.taplo = true
      table.insert(opts.manually_enabled_servers, "taplo")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        toml = { "taplo" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "toml")
      table.insert(opts.highlight_filetypes, "toml")
      table.insert(opts.indent_filetypes, "toml")
    end,
  },
}
