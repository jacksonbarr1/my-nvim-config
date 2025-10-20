return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false, -- neo-tree lazily loads itself
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left", {})
	end,
}
