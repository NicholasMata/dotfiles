return {
	{
		"declancm/cinnamon.nvim",
		version = "*", -- use latest release
		opts = {
			-- change default options here
			-- Enable all provided keymaps
			keymaps = {
				basic = true,
				extra = true,
			},
			-- Only scroll the window
			options = { mode = "window" },
		},
	},
}
