lvim.colorscheme = "catppuccin-mocha"
lvim.transparent_window = true
vim.opt.relativenumber = true

lvim.builtin.which_key.mappings["f"] = {
  require("lvim.core.telescope.custom-finders").find_project_files,
  "Find File"
}

lvim.plugins = {
	{ 'rose-pine/neovim', name = 'rose-pine' },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { 'Hoffs/omnisharp-extended-lsp.nvim', lazy = true, ft = "cs" },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require"lsp_signature".on_attach() end,
  },
  { 'theprimeagen/vim-be-good' },
}

