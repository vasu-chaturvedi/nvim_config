return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    -- Configure notify first (Noice routes to it)
    local notify = require("notify")
    notify.setup({
      timeout = 5000,
      background_colour = "#000000",
      stages = "fade",
      minimum_width = 50,
      render = "compact",
    })
    vim.notify = notify

    local function cmdline_view()
      -- Prefer popup on wide terminals; fall back on narrow ones.
      return (vim.o.columns >= 120) and "cmdline_popup" or "cmdline"
    end

    local function setup_noice()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = cmdline_view(),
          format = {
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
            help = { pattern = "^:%s*h%s+", icon = "󰋖", lang = "vim" },
            input = { view = "cmdline_input", icon = "󰥻 " },
          },
        },

        messages = { enabled = true },
        popupmenu = { enabled = true },

        routes = {
          { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
          { filter = { event = "msg_show", kind = "", find = "yanked" }, opts = { skip = true } },
          { filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
        },

        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },

        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
        },
      })
    end

    setup_noice()

    -- Re-evaluate cmdline view on terminal resize.
    -- Keeps "popup on wide terminals" without restart.
    local group = vim.api.nvim_create_augroup("NoiceResize", { clear = true })
    local timer = vim.uv.new_timer()
    vim.api.nvim_create_autocmd("VimResized", {
      group = group,
      callback = function()
        if not timer then
          return
        end
        timer:stop()
        timer:start(80, 0, function()
          vim.schedule(function()
            pcall(setup_noice)
          end)
        end)
      end,
    })
  end,
}
