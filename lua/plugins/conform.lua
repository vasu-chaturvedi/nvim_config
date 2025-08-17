return {
	"stevearc/conform.nvim",

	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "n", -- set to normal mode

			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 500,

					lsp_format = true, -- use boolean
				}
			end
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			go = { "goimports", "gofmt" },
		},
		formatters = {
			stylua = {
				command = vim.env.NVIM_CONFIG .. "/bin/stylua",
			},
			shfmt = {
				command = vim.env.NVIM_CONFIG .. "/bin/shfmt",
			},
			--formatters_by_ft = {
			--lua = { vim.env.NVIM_CONFIG .. "/bin/stylua" },
			--go = { vim.env.NVIM_CONFIG .. "/bin/goimports", vim.env.NVIM_CONFIG .. "/bin/gofmt" },
			--sh = { vim.env.NVIM_CONFIG .. "/bin/shfmt" },

			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
			--},
		},
	},
}
