-- lua/plugins/oil.lua
return {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",                 -- keep it lazy
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- If any CLI arg is a directory, load Oil and open it there
          for _, arg in ipairs(vim.fn.argv()) do
            if vim.fn.isdirectory(arg) == 1 then
              local ok, lazy = pcall(require, "lazy")
              if ok and lazy and lazy.load then
                lazy.load({ plugins = { "oil.nvim" } })
              end
              require("oil").open(arg)
              return
            end
          end
        end,
      })
    end,
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false, ["<C-j>"] = false, ["<C-k>"] = false, ["<C-l>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name) return name == ".git" end,
      },
    },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Oil: open parent directory" },
      { "<space>-", function() require("oil").toggle_float() end, desc = "Oil: toggle float" },
    },
  },
}

