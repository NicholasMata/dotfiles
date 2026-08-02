return {
  {
    "Kurren123/mssql.nvim",
    -- dir = "~/Developer/Contributed/mssql.nvim",
    opts = {
      -- optional
      keymap_prefix = "<leader>m",
    },
    -- optional
    dependencies = { "folke/which-key.nvim" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "sql-formatter")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sql_formatter" },
      },
      formatters = {
        sql_formatter = {
          prepend_args = { "--language", "transactsql" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "sql")
      table.insert(opts.highlight_filetypes, "sql")
      table.insert(opts.indent_filetypes, "sql")
    end,
  },
}
