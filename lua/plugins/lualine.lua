-- lua/plugins/lualine.lua
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = function()
		local nerd = vim.g.have_nerd_font == true

		-- Custom LSP status: prefer Noice LSP progress; fallback to client count
		local function lsp_status_component()
			local ok_noice, noice = pcall(require, "noice")
			if ok_noice then
				local api_ok, api = pcall(require, "noice").api
				if api_ok and api.status and api.status.lsp_progress and api.status.lsp_progress.has() then
					return api.status.lsp_progress.get()
				end
			end
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients > 0 then
				return (nerd and " " or "LSP ") .. #clients
			end
			return ""
		end

		return {
			options = {
				theme = "auto",
				icons_enabled = nerd,
				disabled_filetypes = { "snacks_dashboard" },

				-- use glyphs only if Nerd Font is present
				component_separators = nerd and { left = "", right = "" } or { left = "|", right = "|" },
				section_separators = nerd and { left = "", right = "" } or { left = "", right = "" },

				-- if you ever want minimal UI in special windows, you can add:
				-- globalstatus is enabled below in config()
			},

			sections = {
				lualine_a = { "mode" },

				lualine_b = {
					{ lsp_status_component, icon = nerd and "" or nil, separator = " ", padding = 1 },
					-- you can also add 'branch' or 'diff' here if you like
				},

				lualine_c = {
					{ "filename", path = 3, shorting_target = 0 }, -- absolute, keep full path
				},

				lualine_x = {
					"filesize",
				},

				lualine_y = {
					"searchcount",
					"selectioncount",
					"encoding",
					"filetype",
				},

				lualine_z = {
					"progress",
					"location",
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		}
	end,
	config = function(_, opts)
		require("lualine").setup(opts)
		vim.opt.laststatus = 3 -- global statusline (good on 0.11.x)
	end,
}
