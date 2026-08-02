return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "biome", "jsonlint" })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        json = { "biome" },
      },
      formatters = {
        biome = {
          require_cwd = true,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        json = { "jsonlint" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "json")
      table.insert(opts.highlight_filetypes, "json")
      table.insert(opts.indent_filetypes, "json")
    end,
  },
}
