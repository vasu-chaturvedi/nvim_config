return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
    vim.keymap.set(
      "n",
      "<leader>hm",
      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Harpoon: menu" }
    )

    -- Leader alternatives (more reliable over SSH/Putty than Alt-#)
    for i = 1, 9 do
      vim.keymap.set("n", ("<leader>%d"):format(i), function() harpoon:list():select(i) end, { desc = "Harpoon: select " .. i })
    end

    -- Keep Alt-# for terminals that support it
    for i = 1, 8 do
      vim.keymap.set("n", ("<M-%d>"):format(i), function() harpoon:list():select(i) end, { desc = "Harpoon: select " .. i })
    end
  end,
}
