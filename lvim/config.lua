lvim.colorscheme = "catppuccin-mocha"
lvim.transparent_window = true
vim.opt.wrap = true
vim.opt.relativenumber = true

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Disable toggle terminal because I use kitty multiplexer
-- lvim.builtin.terminal.active = false
-- Prefer leader -> f to find project file which shows a preview.
lvim.builtin.which_key.mappings["f"] = {
  require("lvim.core.telescope.custom-finders").find_project_files,
  "Find File"
}

lvim.plugins = {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' }
  },
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {}
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
    'Hoffs/omnisharp-extended-lsp.nvim',
    lazy = true,
    ft = "cs"
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  { 'theprimeagen/vim-be-good' },
  { 'theprimeagen/harpoon' },
}

lvim.builtin.nvimtree.setup.view = { relativenumber = true }

vim.diagnostic.config({ virtual_text = false })
lvim.builtin.which_key.mappings["lm"] = {
  '<cmd>lua vim.diagnostic.open_float()<CR>', "Line Diagnostic"
}
lvim.builtin.which_key.mappings["v"] = { 'Speak Word' }
lvim.builtin.which_key.vmappings["v"] = { 'Speak Selection' }
lvim.keys.visual_mode["<leader>v"] = { '"xy:call system(\'say \'. shellescape(@x) .\' &\')<CR>', desc = 'Speak' }
lvim.keys.normal_mode["<leader>v"] = ":call system('say '.shellescape(expand('<cword>')).' &')<CR>"

lvim.builtin.which_key.mappings["m"] = {
  name = "Harpoon",
  m = { "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<CR>", "Menu" },
  a = { "<cmd>:lua require('harpoon.mark').add_file()<CR>", "Add" },
  j = { "<cmd>:lua require('harpoon.ui').nav_next()<CR>", "Next" },
  k = { "<cmd>:lua require('harpoon.ui').nav_prev()<CR>", "Previous" },
  y = { "<cmd>:lua require('harpoon.ui').nav_file(1)<CR>", "Nav File 1" },
  h = { "<cmd>:lua require('harpoon.ui').nav_file(2)<CR>", "Nav File 2" },
  n = { "<cmd>:lua require('harpoon.ui').nav_file(3)<CR>", "Nav File 3" },
}
