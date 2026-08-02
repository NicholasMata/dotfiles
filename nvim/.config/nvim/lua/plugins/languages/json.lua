return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      for _, tool in ipairs({ "biome", "jsonlint" }) do
        if not vim.tbl_contains(opts.ensure_installed, tool) then
          table.insert(opts.ensure_installed, tool)
        end
      end
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
