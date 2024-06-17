return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		keys = {
			{ "<leader>mpp", "<cmd>MarkdownPreview<cr>", desc = "[p]review" },
			{ "<leader>mps", "<cmd>MarkdownPreviewStop<cr>", desc = "[p]review [s]top" },
		},
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
