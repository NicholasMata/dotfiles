reload("user.options")
reload("user.mappings")
reload("user.formatters")
reload("user.linters")

lvim.plugins = {
  -- Better File Explorer
  {
    'stevearc/oil.nvim',
    opts = {
      view_options = {
        show_hidden = true
      }
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- NPM Packge Info
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
  },

  -- Markdown Preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- View colors in editor
  {
    'NvChad/nvim-colorizer.lua',
    config = true
  },

  -- Auto change vim theme
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option('background', 'dark')
      end,
      set_light_mode = function()
        vim.api.nvim_set_option('background', 'light')
      end,
    }
  },

  -- Theme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = true
  },

  -- Database Management
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' }
  },

  -- CSharp
  {
    'nicholasmata/nvim-dap-cs',
    dir = "$HOME/Developer/nvim-dap-cs",
    dev = { true },
    config = true,
    ft = "cs",
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

  { 'tamton-aquib/keys.nvim' },
}

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "csharp_ls" })
