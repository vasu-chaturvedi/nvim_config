return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			cmdline = {
				view = "cmdline_popup",
			},
			timeout = 500,
			views = {
				cmdline_popup = {
					position = { row = "50%", col = "50%" },
					size = { width = 60, height = "auto" },
					border = { style = "rounded", padding = { 0, 1 } },
					win_options = { winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder" },
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						find = "written",
					},
					opts = { skip = true },
				},
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = false,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
		})
		vim.notify = require("notify")
	end,
}
