return {
	"navarasu/onedark.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("onedark").setup({
			style = "dark",
			transparent = true,
			term_colors = true,

			lualine = {
				transparent = true,
			},
		})
		require("onedark").load()
	end,
}
