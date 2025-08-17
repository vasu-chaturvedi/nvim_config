return {
	"VonHeikemen/fine-cmdline.nvim",
	event = "VeryLazy",
	dependencies = { "MunifTanjim/nui.nvim" },

	config = function()
		require("fine-cmdline").setup()
	end,
}
