return {
	"folke/snacks.nvim",
	event = "VeryLazy",
	opts = {
		-- 📢 Popup notifications (vim.notify)
		messages = {
			enabled = true,
			timeout = 3000, -- duration in ms
		},

		-- 🛠️ LSP enhancements
		lsp = {
			progress = { enabled = true }, -- replaces fidget
			hover = { enabled = true }, -- nice floating docs
			signature = { enabled = true }, -- inline param hints
		},

		-- 🧠 UI enhancements for input/select prompts
		select = {
			enabled = true, -- replaces vim.ui.select / dressing
		},
		input = {
			enabled = true, -- replaces vim.ui.input / dressing
		},
	},
}
