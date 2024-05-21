vim.opt.termguicolors = true

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
