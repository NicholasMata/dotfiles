return {
	{
		-- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			local which_key = require("which-key")
			which_key.setup()

			-- Document existing key chains
			which_key.register({
				l = { name = "[l]sp", _ = "which_key_ignore" },
				d = { name = "[d]iagnostic", _ = "which_key_ignore" },
				D = { name = "[D]ebug", _ = "which_key_ignore" },
				s = { name = "[s]earch", _ = "which_key_ignore" },
				g = { name = "[g]it", _ = "which_key_ignore" },
				o = { name = "[o]s", _ = "which_key_ignore" },
				v = { ":call system('say '.shellescape(expand('<cword>')).' &')<CR>", "[v]oice word" },
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
