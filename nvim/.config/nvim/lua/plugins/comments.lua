return {
	-- Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
	-- documentation comments
	{
		"kkoomen/vim-doge",
		lazy = false,
		keys = {
			{ "gcd", "<cmd>DogeGenerate<cr>", desc = "generate documentation comment" },
		},
		build = ":call doge#install()",
	},
}
