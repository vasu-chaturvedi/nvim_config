return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		-- Configure notify first (used by noice for long messages, etc.)
		local ok_notify, notify = pcall(require, "notify")
		if ok_notify then
			notify.setup({
				timeout = 500,
				top_down = false, -- newest at bottom feels natural in terminals
				stages = "fade", -- simple, TUI-friendly animations
				render = "compact",
			})
			vim.notify = notify
		end

		-- Helper: tiny terminals fall back to inline cmdline
		local use_popup = function()
			local cols = vim.o.columns
			return cols >= 80
		end

		require("noice").setup({
			cmdline = {
				view = use_popup() and "cmdline_popup" or "cmdline",
			},
			timeout = 500, -- Noice's own timeout (messages UI)
			views = {
				cmdline_popup = {
					position = { row = "50%", col = "50%" },
					size = { width = 60, height = "auto" },
					border = { style = "rounded", padding = { 0, 1 } },
					win_options = { winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder" },
				},
			},

			-- Be quieter on routine editor chatter
			routes = {
				-- hide "written" messages on :write
				{ filter = { event = "msg_show", find = "written" }, opts = { skip = true } },
				-- hide yank summaries like "3 lines yanked"
				{ filter = { event = "msg_show", find = "yanked" }, opts = { skip = true } },
				-- hide search count messages like "/foo 3/10"
				{ filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
				-- hide "X fewer lines" after joins/deletes, etc.
				{ filter = { event = "msg_show", find = "fewer lines" }, opts = { skip = true } },
			},

			lsp = {
				-- Keep markdown UX overrides for hover/signature/docs
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					-- NOTE: removed cmp.entry.get_documentation since you're using blink.cmp
				},
				-- optional: disable Noice’s signature help if you prefer plain floating
				-- signature = { enabled = true },
				progress = { enabled = true }, -- neat LSP progress notifications via notify
				hover = { silent = true }, -- don’t spam on hover failures
			},

			presets = {
				bottom_search = false, -- you’re using the popup cmdline
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
		})
	end,
}
