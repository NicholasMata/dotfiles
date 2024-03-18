reload("user.options")
reload("user.mappings")
reload("user.formatters")
reload("user.linters")

lvim.plugins = {
  {
    -- NPM Packge Info
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
  },
  {
    -- Markdown Preview
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    -- View colors in editor
    'NvChad/nvim-colorizer.lua'
  },
  {
    -- Auto change vim theme
    'f-person/auto-dark-mode.nvim'
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine'
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' }
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  { 'theprimeagen/vim-be-good' },
  { 'theprimeagen/harpoon' },
  { 'nicholasmata/nvim-dap-cs', dependencies = { 'mfussenegger/nvim-dap' } }
}

reload("dap-cs").setup()
