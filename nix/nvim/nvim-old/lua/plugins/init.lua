-- Get current window
--

local get_current_window = function()
	return vim.api.nvim_win_get_number(0)
end

return {
	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',


	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
		},
	},




	{
		'folke/which-key.nvim',
		opts = {}
	},


	-- install different completion source
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",



	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		'lewis6991/gitsigns.nvim',
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
			on_attach = function(bufnr)
				vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
					{ buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
				vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
				vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
			end,
		},
	},


	{
		-- Set lualine as statusline
		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				theme = 'onedark',
				component_separators = '|',
				section_separators = '',
			},
			inactive_sections = {
				lualine_a = { get_current_window },
				lualine_b = {},
				lualine_c = { 'filename' },
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {}
			},
		},
	},



	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		main = 'ibl',
		opts = {
			indent = {
				-- char = '┊',
				char = '┆',
			}
		},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },


	-- Fuzzy Finder (files, lsp, etc)
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			"folke/trouble.nvim",
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				-- NOTE:  Read README for telescope-fzf-native for instruction if issues arise.
				--        MAKE needs to be available for it to load.
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
		},
	},

	-- File system
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
