-- Get current window
--

local get_current_window = function()
	return vim.api.nvim_win_get_number(0)
end

return {
	-- Git related plugins
	'tpope/vim-rhubarb',




	{
		'folke/which-key.nvim',
		opts = {}
	},

	{
		'stevearc/oil.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		opts = {
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						vim.cmd.Neotree("close")
					end,
					id = "close-on-enter",
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		cmd = {
			"Neotree",
		},
		keys = {
			{
				"-",
				function()
					vim.cmd.Neotree("reveal", "toggle=true", "position=current")
				end,
				mode = "n",
				desc = "Toggle Neotree",
			},
		},
	},

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
