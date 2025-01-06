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
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gl", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
