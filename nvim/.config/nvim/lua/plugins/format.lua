return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	{
		-- Autoformat
		"stevearc/conform.nvim",
		lazy = false,
		opts = {
			notify_on_error = false,
			stop_after_first = true,
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
				typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
				javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
				json = { "biome" },
				xml = {
					command = "xmllint",
					args = { "--format", "-" },
					stdin = true,
				},
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			vim.api.nvim_create_user_command("FormatDisable", function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})

			vim.api.nvim_create_user_command("FormatEnable", function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end, {
				desc = "Re-enable autoformat-on-save",
			})

			vim.api.nvim_set_keymap(
				"n",
				"<leader>fd",
				":FormatDisable<CR>",
				{ noremap = true, silent = true, desc = "[f]ormat [d]isable" }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>fe",
				":FormatEnable<CR>",
				{ noremap = true, silent = true, desc = "[f]ormat [e]nable" }
			)
			vim.keymap.set("n", "<leader>fb", function()
				require("conform").format({ async = true, lsp_fallback = true })
			end, { noremap = true, silent = true, desc = "[f]ormat [b]uffer" })
		end,
	},
}
