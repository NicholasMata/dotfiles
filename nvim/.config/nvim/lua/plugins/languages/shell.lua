return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.bashls = {
        filetypes = { "sh", "zsh" },
      }
      table.insert(opts.ensure_installed, "bash-language-server")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "bash")
      table.insert(opts.highlight_filetypes, "bash")
      table.insert(opts.indent_filetypes, "bash")
    end,
  },
}
