return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.kotlin_language_server = {}
      table.insert(opts.ensure_installed, "ktlint")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        kotlin = { "ktlint" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "kotlin")
      table.insert(opts.highlight_filetypes, "kotlin")
      table.insert(opts.indent_filetypes, "kotlin")
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "codymikol/neotest-kotlin.nvim",
    },
    opts = function(_, opts)
      opts.adapters.kotlin = function()
        return require("neotest-kotlin")
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "kotlin")
    end,
  },
}
