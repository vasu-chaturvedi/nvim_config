return {
	-- Single, self-contained spec (Lazy-style)
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" }, -- lazy-load on files
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = function()
			-- If you use a custom parser dir, append it to rtp (offline)
			local parser_dir = vim.fn.stdpath("config") .. "/parsers"
			if vim.fn.isdirectory(parser_dir) == 1 then
				vim.opt.runtimepath:append(parser_dir)
			end

			require("nvim-treesitter.configs").setup({
				-- Keep only what you actually need
				ensure_installed = {}, -- empty -> no network calls
				auto_install = false, -- never try to install online
				sync_install = false,
				-- parser_install_dir = parser_dir, -- uncomment if you want to force this path

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },

				incremental_selection = {
					enable = true,
					keymaps = {
						-- retain your style, but feel free to change
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = false,
						node_decremental = "<BS>",
					},
				},

				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						-- avoid your Harpoon <leader>a conflict
						swap_next = { ["<leader>sn"] = "@parameter.inner" },
						swap_previous = { ["<leader>sN"] = "@parameter.inner" },
					},
				},
			})
		end,
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
