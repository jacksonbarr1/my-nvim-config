return {
	"saghen/blink.nvim",
	dependencies = { "rafamadriz/friendly-snippets", "LuaSnip", "giuxtaposition/blink-cmp-copilot" },
	build = "cargo +nightly build --release",
	opts = {
		keymap = {
			["<cr>"] = { "accept", "fallback" },
			["<C-\\>"] = { "hide", "fallback" },
			["<C-n>"] = { "select_next", "show" },
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<C-p>"] = { "select_prev" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
			kind_icons = require("jacksonbarr1.icons").symbol_kinds,
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot" },
			providers = {
				buffer = {
					opts = {
						get_bufnrs = function()
							return vim.tbl_filter(function(bufnr)
								return vim.bo[bufnr].buftype == ""
							end, vim.api.nvim_list_bufs())
						end,
					},
				},
				path = {
					opts = {
						get_cwd = function(_)
							return vim.fn.getcwd()
						end,
					},
				},
				copilot = {
					name = "copilot",
					module = "blink-cmp-copilot",
					score_offset = 100,
					async = true,
				}
			},
		},
		completion = {
			menu = {
				auto_show_delay_ms = 500,
				scrollbar = false,
			},
			list = {
				selection = { preselect = false, auto_insert = false }, -- try this
				max_items = 10,
			},
			documentation = { auto_show = true },
		},
		snippets = { preset = "luasnip" },
	},

	config = function(_, opts)
		require("blink.cmp").setup(opts)
	end,
}
