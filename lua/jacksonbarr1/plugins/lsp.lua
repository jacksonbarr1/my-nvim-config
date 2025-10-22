local diagnostic_icons = require("jacksonbarr1.icons").diagnostics

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"j-hui/fidget.nvim",
		"saghen/blink.cmp",
	},

	opts = {
		servers = {
			lua_ls = {},
			clangd = {},
			eslint = {},
			copilot = {},
		},
	},

	config = function(_, opts)

		for server, config in pairs(opts.servers) do
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			vim.lsp.config(server, config)
		end

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"eslint",
			},
			handlers = {
				function(server_name)
					vim.lsp.enable(server_name)
				end,
			}
		})

		vim.diagnostic.config({
			virtual_text = {
				severity = nil,
				source = "if_many",
				format = function(diagnostic)
					local reduced = { ["Lua Diagnostics."] = "", ["Lua Syntax Check."] = "" }
					local msg = diagnostic_icons[vim.diagnostic.severity[diagnostic.severity]]
					if reduced[diagnostic.message] ~= nil then
						return msg .. " " .. reduced[diagnostic.message]
					end
					return msg .. " " .. diagnostic.message
				end,
				prefix = "",
				spacing = 4,
			},
			float = {
				border = "rounded",
				source = false,
				format = function(d)
					return d.message
				end,
				prefix = function(diag)
					local level = vim.diagnostic.severity[diag.severity]
					local pref = string.format(" %s ", diagnostic_icons[level])
					return pref, "Diagnostic" .. level:gsub("^%l", string.upper)
				end,
			},
			signs = false,
		})
	end,
}
