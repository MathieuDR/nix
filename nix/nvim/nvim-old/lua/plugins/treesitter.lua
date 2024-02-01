return {
	{
		-- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		lazy = true,
		event = { "BufReadPost", "BufNewFile" },
		enabled = true,
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			"nvim-treesitter/nvim-treesitter-context"
		},
		build = ':TSUpdate'
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = true,
		enabled = true,
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("treesitter-context").setup()
		end,
	},
}
