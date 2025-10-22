return {
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "v2.*",
		build = "make install_jsregexp",

		opts = function()
			local types = require("luasnip.util.types")
			return {
				-- Check if current snippet was deleted
				delete_check_events = "TextChanged",
				-- Display a cursor-like placeholder in unvisited nodes of the snippet
				ext_opts = {
					[types.insertNode] = {
						unvisited = {
							virt_text = { { "|", "Conceal" } },
							virt_text_pos = "inline",
						},
					},
					[types.exitNode] = {
						unvisited = {
							virt_text = { { "|", "Conceal" } },
							virt_text_pos = "inline",
						},
					},
					[types.choiceNode] = {
						active = {
							virt_text = { { "(snippet) choice node", "LspInlayHint" } },
						},
					},
				},
			}
		end,

		config = function(_, opts)
			local ls = require("luasnip")
			ls.setup(opts)

			vim.keymap.set({ "i" }, "<C-s>e", function()
				ls.expand()
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-s>;", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-s>,", function()
				ls.jump(-1)
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })
		end,
	},
}
