return {
	{ "tpope/vim-dadbod" },
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		config = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_win_position = "right"
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_auto_execute_table_helpers = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"
			vim.g.db_ui_picker = "fzf_lua"
		end,
		keys = {
			{ "<leader>du", "<cmd>DBUI<CR>", desc = "Open Dadbod UI" },
			{ "<leader>df", "<cmd>DBUIFindBuffer<CR>", desc = "Find DB buffer" },
			{ "<leader>dq", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
		},
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		ft = { "sql", "mysql", "plsql" },
		config = function()
			vim.g.db_completion_enable = 1
		end,
	},
}
