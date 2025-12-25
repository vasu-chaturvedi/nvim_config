-- lua/plugins/lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = function()
    local nerd = vim.g.have_nerd_font == true

    -- Prefer Noice LSP progress (if available), otherwise show number of attached LSP clients.
    local function lsp_status_component()
      local ok_noice, noice = pcall(require, "noice")
      if ok_noice and noice and noice.api and noice.api.status and noice.api.status.lsp then
        local lsp = noice.api.status.lsp
        if lsp.has and lsp.has() then
          return lsp.get()
        end
      end

      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if not clients or #clients == 0 then
        return ""
      end
      return ("LSP:%d"):format(#clients)
    end

    local function macro_recording()
      local reg = vim.fn.reg_recording()
      if reg == "" then
        return ""
      end
      return ("REC @%s"):format(reg)
    end

    return {
      options = {
        icons_enabled = nerd,
        theme = "auto",
        component_separators = nerd and { left = "", right = "" } or { left = "|", right = "|" },
        section_separators = nerd and { left = "", right = "" } or { left = "", right = "" },
        globalstatus = true, -- 0.11.x: global statusline
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn", "info", "hint" },
            colored = true,
            update_in_insert = false,
          },
        },
        lualine_c = {
          { "filename", path = 3, shorting_target = 0 }, -- absolute
        },
        lualine_x = {
          { macro_recording },
          { lsp_status_component, icon = nerd and "󰒋" or "" },
          "filesize",
        },
        lualine_y = { "searchcount", "selectioncount", "encoding", "fileformat", "filetype" },
        lualine_z = { "location", "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
    vim.opt.laststatus = 3
  end,
}
