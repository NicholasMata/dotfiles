vim.opt.termguicolors = true
require('rose-pine').setup()

lvim.colorscheme = "rose-pine"
lvim.transparent_window = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2    -- insert 2 spaces for a tab
lvim.builtin.dap.active = true

-- Disable toggle terminal because I use kitty multiplexer
-- lvim.builtin.terminal.active = false

lvim.builtin.nvimtree.setup.view = { relativenumber = true }

vim.diagnostic.config({ virtual_text = false })

lvim.builtin.telescope.pickers = { find_files = { hidden = true } }


local auto_dark_mode = require('auto-dark-mode')

auto_dark_mode.setup({
  update_interval = 1000,
  set_dark_mode = function()
    vim.api.nvim_set_option('background', 'dark')
  end,
  set_light_mode = function()
    vim.api.nvim_set_option('background', 'light')
  end,
})

require 'colorizer'.setup()
