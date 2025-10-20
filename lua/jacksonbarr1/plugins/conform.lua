return {
	"stevearc/conform.nvim",
	opts = {},
	lazy = false,
		keys = {
			{
				"<leader>tf",
				function()
					-- If autoformat is currently disabled for this buffer,
					-- then enable it, otherwise disable it
					if vim.b.disable_autoformat or vim.g.disable_autoformat then
						vim.cmd("FormatEnable")
						vim.notify("Enabled autoformat for current buffer")
					else
						vim.cmd("FormatDisable!")
						vim.notify("Disabled autoformat for current buffer")
					end
				end,
				desc = "Toggle autoformat for current buffer",
			},
			{
				"<leader>tF",
				function()
					-- If autoformat is currently disabled globally,
					-- then enable it globally, otherwise disable it globally
					if vim.g.disable_autoformat then
						vim.cmd("FormatEnable")
						vim.notify("Enabled autoformat globally")
					else
						vim.cmd("FormatDisable")
						vim.notify("Disabled autoformat globally")
					end
				end,
				desc = "Toggle autoformat globally",
			},
		},
	config = function()
		require("conform").setup({
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                local disable_filetypes = { }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.b[bufnr].filetype],
                }
            end,
			formatters_by_ft = {
				c = { "clang-format" },
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
			},
		})

		vim.keymap.set("n", "<leader>lf", function()
			require("conform").format({ bufnr = 0 })
		end)

        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- :FormatDisable! disables autoformat for this buffer only
                vim.b.disable_autoformat = true
            else
                -- :FormatDisable disables autoformat globally
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true, -- allows the ! variant
        })

        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })
	end,
}
