return {
	{
		-- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			local wk = require("which-key")
			wk.setup()

			-- Declare leader groups (no rhs)
			wk.add({
				{ "m", group = "[m]arkdown" },
				{ "mp", group = "[p]review" },
				{ "l", group = "[l]sp" },
				{ "d", group = "[d]ebug" },
				{ "t", group = "[t]elescope" },
				{ "g", group = "[g]it" },
				{ "o", group = "[o]s" },
			}, { mode = "n", prefix = "<leader>" })
		end,
	},
}
