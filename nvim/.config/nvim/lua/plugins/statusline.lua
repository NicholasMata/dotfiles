return {
	{
		"nicholasmata/sttusline",
		branch = "fix/deprecation_buf_get_clients",
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
