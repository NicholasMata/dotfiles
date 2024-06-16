return {
	{
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog" },
		keys = {
			{ "<leader>gg", "<cmd>Flog<cr>", desc = "[g]raph" },
		},
		dependencies = {
			"tpope/vim-fugitive",
		},
	},
}
