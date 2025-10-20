return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"javascript",
					"lua",
					"python",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
				},

				sync_install = false,

				auto_install = true,

				indent = {
					enable = true,
				},

				highlight = {
					enable = true,
					disable = function(lang, buf)
						if lang == "html" then
							return true
						end

						local max_filesize = 100 * 1024 -- 100KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							vim.notify(
								"Disabling Treesitter - File larger than 100KB",
								vim.log.levels.WARN,
								{ title = "Treesitter" }
							)
							return true
						end
					end,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		after = "nvim-treesitter",
	},
}
