reload("user.options")
reload("user.mappings")

lvim.plugins = {
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
