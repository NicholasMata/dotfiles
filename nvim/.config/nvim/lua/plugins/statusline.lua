return {
	{
		"sontungexpt/sttusline",
		branch = "table_version",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = { "BufEnter" },
		config = function(_, opts)
			require("sttusline").setup(opts)
			vim.opt.laststatus = 3
		end,
	},
}
