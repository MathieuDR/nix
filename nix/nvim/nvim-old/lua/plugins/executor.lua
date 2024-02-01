return {
	"google/executor.nvim",
	event = "VeryLazy",
	config = function()
		require("executor").setup({})
	end,
	dependencies = {
		"MunifTanjim/nui.nvim"
	}
}
