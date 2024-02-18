-- Get current window
--


return {
	-- Screenshot
	{
		"0oAstro/silicon.lua",
		opts = {
			theme = "dark",
			font = "JetBrainsMono Nerd Font",
			lineNumber = true,
			padHoriz = 60, -- Horizontal padding
			padVert = 40, -- vertical padding
			shadowBlurRadius = 0,
			windowControls = false,
		},
		keys = {
			{
				"<leader>ss",
				function()
					require("silicon").visualise_api {}
				end,
				mode = "v",
				desc = "Take a silicon code snippet",
			},
			{
				"<leader>sc",
				function()
					require("silicon").visualise_api { to_clip = true }
				end,
				mode = "v",
				desc = "Take a silicon code snippet into the clipboard",
			},
		},
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}
