return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
      { "<leader>tf", desc = "Toggle floating terminal" },
      { "<leader>th", desc = "Toggle horizontal terminal" },
      { "<leader>tv", desc = "Toggle vertical terminal" },
    },
    config = function()
      require("toggleterm").setup({
        shade_terminals = true,
        persist_size = true,
        direction = "float",
        float_opts = { border = "rounded" },
      })

      local Terminal = require("toggleterm.terminal").Terminal

      local term_float = Terminal:new({ id = 1, direction = "float" })
      local term_horiz = Terminal:new({ id = 2, direction = "horizontal", size = 12 })
      local term_vert = Terminal:new({ id = 3, direction = "vertical", size = 80 })

      vim.keymap.set("n", "<leader>tf", function() term_float:toggle() end, { desc = "Toggle floating terminal" })
      vim.keymap.set("n", "<leader>th", function() term_horiz:toggle() end, { desc = "Toggle horizontal terminal" })
      vim.keymap.set("n", "<leader>tv", function() term_vert:toggle() end, { desc = "Toggle vertical terminal" })
    end,
  },
}
