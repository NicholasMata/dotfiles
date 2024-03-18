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
    -- Theme
    'rose-pine/neovim',
    name = 'rose-pine'
  },
  {
    -- Database Management
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' }
  },
  -- CSharp
  {
    'nicholasmata/nvim-dap-cs',
    dependencies = { 'mfussenegger/nvim-dap' }
  },
  { 'Hoffs/omnisharp-extended-lsp.nvim' },
  -- Misc
  {
    'kkoomen/vim-doge',
    build = ":call doge#install()"
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  { 'theprimeagen/vim-be-good' },
  { 'theprimeagen/harpoon' },

}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "csharp_ls" })

reload("dap-cs").setup()
