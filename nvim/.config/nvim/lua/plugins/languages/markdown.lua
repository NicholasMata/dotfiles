return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    config = function()
      vim.keymap.set("n", "<leader>pp", "<cmd>MarkdownPreview<cr>", { desc = "[p]review" })
      vim.keymap.set("n", "<leader>ps", "<cmd>MarkdownPreviewStop<cr>", { desc = "[s]top" })
    end,
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "rumdl" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "markdown")
      table.insert(opts.highlight_filetypes, "markdown")
      table.insert(opts.indent_filetypes, "markdown")
    end,
  },
}
