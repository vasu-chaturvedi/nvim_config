-- lua/plugins/oil.lua
return {
  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          -- If any CLI arg is a directory, load Oil and open it there
          for _, arg in ipairs(vim.fn.argv()) do
            if vim.fn.isdirectory(arg) == 1 then
              local ok, lazy = pcall(require, "lazy")
              if ok and lazy and lazy.load then
                lazy.load({ plugins = { "oil.nvim" } })
              end
              vim.schedule(function()
                local ok_oil, oil = pcall(require, "oil")
                if ok_oil then
                  oil.open(arg)
                end
              end)
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
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,

        ["<M-h>"] = "actions.select_split", -- horizontal split
        ["<M-l>"] = "actions.select_vsplit", -- vertical split
        ["<M-p>"] = "actions.preview",
        ["q"] = "actions.close",
      },

      float = {
        padding = 2,
        max_width = 0.90,
        max_height = 0.90,
        border = "rounded",
        win_options = { winblend = 0 },
      },

      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".git"
        end,
      },
    },

    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Oil: open parent directory" },
      { "<space>-", function() require("oil").toggle_float() end, desc = "Oil: toggle float" },
    },
  },
}
