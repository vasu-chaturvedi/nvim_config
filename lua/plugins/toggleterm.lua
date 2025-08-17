return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup()
			vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
			vim.keymap.set("n", "<leader>tf", function()
				require("toggleterm").toggle(1, 20, vim.fn.getcwd(), "float")
			end, { desc = "Toggle floating terminal" })
			vim.keymap.set("n", "<leader>th", function()
				require("toggleterm").toggle(2, 10, vim.fn.getcwd(), "horizontal")
			end, { desc = "Toggle horizontal terminal" })
			vim.keymap.set("n", "<leader>tv", function()
				require("toggleterm").toggle(3, 80, vim.fn.getcwd(), "vertical")
			end, { desc = "Toggle vertical terminal" })
		end,
	},
}
