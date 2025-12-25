return {
  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.compat" },
    version = "*",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<C-y>"] = { "accept", "fallback" }, -- avoid <C-z> (terminal suspend)
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      completion = {
        documentation = {
          auto_show = false, -- less noisy with Noice/Notify; use <C-Space> to toggle docs
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = { name = "LSP", module = "blink.cmp.sources.lsp", score_offset = 100 },
          path = { name = "Path", module = "blink.cmp.sources.path", score_offset = 90 },
          snippets = { name = "Snippets", module = "blink.cmp.sources.snippets", score_offset = 80 },
          buffer = { name = "Buffer", module = "blink.cmp.sources.buffer", score_offset = 60 },

          -- Emoji completion (optional)
          emoji = {
            name = "Emoji",
            module = "blink.compat.source",
            score_offset = 20,
            opts = { kind = "Emoji", max_items = 50 },
            enabled = function()
              return vim.tbl_contains({ "gitcommit", "markdown", "text" }, vim.bo.filetype)
            end,
          },

          -- SQL completion via cmp-sql (optional)
          sql = {
            name = "SQL",
            module = "blink.compat.source",
            score_offset = 30,
            opts = {
              kind = "SQL",
              max_items = 50,
              -- cmp-sql config (if installed)
              config = {
                sources = {
                  { name = "sql", option = { group = "default" } },
                },
              },
            },
            enabled = function()
              return vim.tbl_contains({ "sql", "mysql", "plsql" }, vim.bo.filetype)
            end,
          },
        },
      },

      -- Offline-friendly: prefer Lua fallback if Rust build isn't available
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
