-- lua/plugins/fzf.lua
return {
	{
		"ibhagwan/fzf-lua",
		-- `keys` creates lazy keymaps that auto-load the plugin on first press
		keys = {
			-- Use command strings when no extra options are needed (fastest path)
			{ "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Grep" },
			{ "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Grep word" },
			{ "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
			{ "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Diagnostics (buffer)" },
			{ "<leader>fr", "<cmd>FzfLua resume<CR>", desc = "Resume" },
			{ "<leader>f.", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
			{ "<leader>/", "<cmd>FzfLua blines<CR>", desc = "Search in buffer" },

			-- When you need options, use a function; Lazy will still load-on-press
			{
				"<leader>s/",
				function()
					require("fzf-lua").live_grep({ grep_open_files = true, prompt = "Grep in Open Files" })
				end,
				desc = "Grep in open files",
			},

			-- Avoid TS swap-next conflict; use <leader>fn for NVim config files
			{
				"<leader>fn",
				function()
					require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Neovim config files",
			},

			-- Optional: visual-mode searches
			{
				"<leader>ss",
				function()
					local sel = vim.fn.trim(vim.fn.getreg("v"))
					require("fzf-lua").live_grep({ search = sel })
				end,
				mode = "v",
				desc = "Live grep selection",
			},
			{
				"<leader>sw",
				function()
					local sel = vim.fn.getreg("v")
					require("fzf-lua").grep({ search = sel, no_esc = true, exact = true })
				end,
				mode = "v",
				desc = "Grep selection (literal)",
			},
		},

		-- (Optional) also allow :FzfLua to trigger lazy-load
		cmd = "FzfLua",

		dependencies = {
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},

		-- normal opts/config as before
		opts = function()
			-- offline: add your portable bin to PATH so `rg`/`fzf` are found
			local BIN = (vim.env.NVIM_CONFIG or vim.fn.stdpath("config")) .. "/bin"
			if vim.fn.isdirectory(BIN) == 1 and not (vim.env.PATH or ""):find(BIN, 1, true) then
				vim.env.PATH = BIN .. ":" .. vim.env.PATH
			end
			local has_bat = vim.fn.executable("bat") == 1
			return {
				winopts = {
					height = 0.98,
					width = 0.98,
					row = 0.01,
					col = 0.01,
					preview = {
						default = has_bat and "bat" or "builtin",
						border = "rounded",
						layout = "horizontal",
						horizontal = "right:70%",
						vertical = "up:80%",
						title = "Preview",
					},
				},
				keymap = { builtin = { ["<C-j>"] = "down", ["<C-k>"] = "up" } },
				grep = { rg_opts = [[--hidden --line-number --column --no-heading --smart-case -g !.git/]] },
			}
		end,
		config = function(_, opts)
			require("fzf-lua").setup(opts)
		end,
	},
}
