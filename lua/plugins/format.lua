return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "n",
      desc = "Format buffer",
    },
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "v",
      desc = "Format selection",
    },
  },

  opts = function()
    local cfg_root = vim.env.NVIM_CONFIG
    if not cfg_root or cfg_root == "" then
      cfg_root = vim.fn.stdpath("config")
    end

    return {
      notify_on_error = true,

      format_on_save = function(bufnr)
        local disabled = { c = true, cpp = true }
        if disabled[vim.bo[bufnr].filetype] then
          return
        end
        return { timeout_ms = 3000, lsp_fallback = true }
      end,

      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        sh = { "shfmt" },
        json = { "jq" },
        yaml = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        html = { "prettier" },

        -- Go: goimports already formats; no need to run gofmt after it
        go = { "goimports" },
      },

      formatters = {
        goimports = { command = cfg_root .. "/bin/goimports" },
        stylua = { command = cfg_root .. "/bin/stylua" },
        shfmt = { command = cfg_root .. "/bin/shfmt" },
        black = { command = cfg_root .. "/bin/black" },
        prettier = { command = cfg_root .. "/bin/prettier" },
        jq = { command = cfg_root .. "/bin/jq" },
      },
    }
  end,
}
