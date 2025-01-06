return {
	-- Auto change vim theme on mode
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option("background", "dark")
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
			end,
			set_light_mode = function()
				vim.api.nvim_set_option("background", "light")
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
			end,
		},
	},
	-- Theme
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = true,
		init = function()
			vim.cmd.colorscheme("rose-pine")
		end,
	},
}
