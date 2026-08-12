return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = { "lua" },
        opts = { library = { "lazy.nvim", { path = "snacks.nvim", words = { "Snacks" } } } },
      },
    },
    opts = function(_, opts)
      opts.servers.lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.fn.stdpath("config") .. "/lua",
                vim.api.nvim_get_runtime_file("", true),
                vim.env.VIMRUNTIME,
              },
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua", "luadoc" })
      table.insert(opts.highlight_filetypes, "lua")
      table.insert(opts.indent_filetypes, "lua")
    end,
  },
}
