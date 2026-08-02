local dap_cs_path = vim.fn.expand("~/Developer/nvim-dap-cs")
if vim.fn.isdirectory(dap_cs_path) == 0 then
  dap_cs_path = nil
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "seblyng/roslyn.nvim",
        ft = "cs",
        opts = {},
      },
    },
    opts = function(_, opts)
      opts.servers.roslyn = {
        cmd = {
          "roslyn-language-server",
          "--logLevel=Information",
          "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
          "--stdio",
        },
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      }
      opts.externally_managed_servers.roslyn = true
      table.insert(opts.ensure_installed, "roslyn-language-server")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "c_sharp")
      table.insert(opts.highlight_filetypes, "cs")
      table.insert(opts.indent_filetypes, "cs")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "coreclr")
    end,
  },
  {
    "nicholasmata/nvim-dap-cs",
    ft = "cs",
    dir = dap_cs_path,
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
}
