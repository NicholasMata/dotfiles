return {
	"stevearc/oil.nvim",
	lazy = false,
	opts = {
		default_file_explorer = true,
		view_options = {
			show_hidden = true,
		},
	},
	keys = {
		{
			"<leader>n",
			"<cmd>Oil<cr>",
			desc = "[n]avigation",
		},
	},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
