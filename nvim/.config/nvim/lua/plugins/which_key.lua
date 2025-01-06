return {
	{
		-- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			local which_key = require("which-key")
			which_key.setup()

			-- Document existing key chains
			which_key.add({
				{ "<leader>m", group = "[m]arkdown" },
				{ "<leader>mp", group = "[p]review" },
				{ "<leader>l", group = "[l]sp" },
				{ "<leader>d", group = "[d]ebug" },
				{ "<leader>t", group = "[t]elescope" },
				{ "<leader>g", group = "[g]it" },
				{ "<leader>o", group = "[o]s" },
				{ "<leader>v", ":call system('say '.shellescape(expand('<cword>')).' &')<CR>", name = "[v]oice word" },
			}, { mode = "n", prefix = "<leader>" })
			-- visual mode
			--
			-- lvim.builtin.which_key.mappings["v"] = { 'Speak Word' }
			-- lvim.builtin.which_key.vmappings["v"] = { 'Speak Selection' }
			-- lvim.keys.visual_mode["<leader>v"] = { '"xy:call system(\'say \'. shellescape(@x) .\' &\')<CR>', desc = 'Speak' }
			-- lvim.keys.normal_mode["<leader>v"] = ":call system('say '.shellescape(expand('<cword>')).' &')<CR>"
			-- which_key.register({
			--   h = { 'Git [H]unk' },
			--   v = { '"xy:call system(\'say \'. shellescape(@x) .\' &\')<CR>', 'Speak Selection' }
			-- }, { mode = 'v', prefix = '<leader>' })
		end,
	},
}
