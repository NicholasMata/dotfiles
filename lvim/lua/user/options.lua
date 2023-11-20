lvim.colorscheme = "catppuccin-mocha"
lvim.transparent_window = true
vim.opt.relativenumber = true
lvim.builtin.dap.active = true

-- Disable toggle terminal because I use kitty multiplexer
-- lvim.builtin.terminal.active = false

lvim.builtin.nvimtree.setup.view = { relativenumber = true }

vim.diagnostic.config({ virtual_text = false })

lvim.builtin.telescope.pickers = { find_files = { hidden = true } }
