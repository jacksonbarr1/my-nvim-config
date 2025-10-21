local diagnostic_icons = require("jacksonbarr1.icons").diagnostics

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"stevearc/conform.nvim",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
        "onsails/lspkind.nvim"
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
        local lspkind = require("lspkind")

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"eslint",
			},
			handlers = {
				function(server_name) -- default handler
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								format = {
									enable = true,
									defaultConfig = {
										indent_style = "space",
										indent_size = "2",
									},
								},
							},
						},
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    show_labelDetails = true,
                    before = function(entry, vim_item)
                        vim_item.menu = ({
                            copilot  = "[Copilot]",
                            nvim_lsp = "[LSP]",
                            luasnip  = "[Snippet]",
                            buffer   = "[Buffer]",
                            path     = "[Path]",
                        })[entry.source.name] or ""
                        return vim_item
                    end,
                }),
            },
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ["<C-e>"] = cmp.mapping.abort(),
			}),
			sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1000 },
                { name = "copilot", priority = 900 },
                { name = "luasnip", priority = 750 },
                { name = "path", priority = 500 },
            }, {
                { name = "buffer", priority = 250, keyword_length = 3 },
            }),
            performance = {
                max_view_entries = 20,
            },
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
