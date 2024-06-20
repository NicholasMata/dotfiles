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
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	-- documentation comments
	{
		"kkoomen/vim-doge",
		lazy = false,
		keys = {
			{ "gcd", "<cmd>DogeGenerate<cr>", desc = "generate documentation comment" },
		},
		build = ":call doge#install()",
		init = function()
			vim.g.doge_javascript_settings = {
				destructuring_props = 1,
				omit_redundant_param_types = 1,
			}
		end,
	},
}
