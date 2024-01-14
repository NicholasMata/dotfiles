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
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    -- View colors in editor
    'norcalli/nvim-colorizer.lua'
  },
  {
    'f-person/auto-dark-mode.nvim'
  },
  {
    'Decodetalkers/csharpls-extended-lsp.nvim'
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' }
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine'
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
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
