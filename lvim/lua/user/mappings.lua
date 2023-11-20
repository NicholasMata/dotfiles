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

-- Prefer leader -> f to find project file which shows a preview.
lvim.builtin.which_key.mappings["f"] = {
  require("lvim.core.telescope.custom-finders").find_project_files,
  "Find File"
}

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


