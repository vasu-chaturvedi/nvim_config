return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
				key = function()
					return vim.loop.cwd()
				end,
			},
			ui = {
				border = "rounded",
				width = 60,
			},
		})

		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		vim.keymap.set("n", "<m-1>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<m-2>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<m-3>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<m-4>", function()
			harpoon:list():select(4)
		end)
		vim.keymap.set("n", "<m-5>", function()
			harpoon:list():select(5)
		end)
		vim.keymap.set("n", "<m-6>", function()
			harpoon:list():select(6)
		end)
		vim.keymap.set("n", "<m-7>", function()
			harpoon:list():select(7)
		end)
		vim.keymap.set("n", "<m-8>", function()
			harpoon:list():select(8)
		end)

		vim.keymap.set("n", "<leader>ar", function()
			harpoon:list():remove()
		end, { desc = "[A] Remove from Harpoon" })
		vim.keymap.set("n", "<leader>an", function()
			harpoon:list():next()
		end, { desc = "[A] Next Harpoon" })
		vim.keymap.set("n", "<leader>ap", function()
			harpoon:list():prev()
		end, { desc = "[A] Previous Harpoon" })
	end,
}
