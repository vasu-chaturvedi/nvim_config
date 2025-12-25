return {
  -- Keep themes installed, but enable only one by default to reduce confusion.
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    enabled = true,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = false,
        terminal_colors = true,
      })
      vim.cmd.colorscheme("tokyonight")

      -- Lightweight theme switcher:
      -- :Colors tokyonight | :Colors kanagawa | etc.
      vim.api.nvim_create_user_command("Colors", function(cmd)
        local name = cmd.args
        if name == "" then
          vim.notify("Usage: :Colors <colorscheme>", vim.log.levels.WARN)
          return
        end
        local ok = pcall(vim.cmd.colorscheme, name)
        if not ok then
          vim.notify(("Colorscheme not found: %s"):format(name), vim.log.levels.ERROR)
        end
      end, { nargs = 1, complete = "color" })
    end,
  },

  { "sainnhe/gruvbox-material", priority = 900, enabled = false },
  { "rebelot/kanagawa.nvim", priority = 900, enabled = false },
  { "EdenEast/nightfox.nvim", priority = 900, enabled = false },
  { "rose-pine/neovim", name = "rose-pine", priority = 900, enabled = false },
  { "catppuccin/nvim", name = "catppuccin", priority = 900, enabled = false },
}
