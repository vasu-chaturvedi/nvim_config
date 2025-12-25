-- lua/plugins/fzf.lua
return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
      { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
      { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Grep word under cursor" },
      { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
      { "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Commands" },
      { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
      { "<leader>fm", "<cmd>FzfLua marks<CR>", desc = "Marks" },

      -- Git
      { "<leader>gf", "<cmd>FzfLua git_files<CR>", desc = "Git files" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Git status" },

      -- LSP
      { "gr", "<cmd>FzfLua lsp_references<CR>", desc = "LSP references" },
      { "gd", "<cmd>FzfLua lsp_definitions<CR>", desc = "LSP definitions" },
      { "gI", "<cmd>FzfLua lsp_implementations<CR>", desc = "LSP implementations" },
      { "<leader>ds", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
      { "<leader>ws", "<cmd>FzfLua lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
    },

    opts = function()
      local cfg_root = vim.env.NVIM_CONFIG
      if not cfg_root or cfg_root == "" then
        cfg_root = vim.fn.stdpath("config")
      end

      local fzf_bin = cfg_root .. "/bin"
      local bat = fzf_bin .. "/bat"

      -- Add portable tools to PATH (offline-friendly)
      if vim.fn.isdirectory(fzf_bin) == 1 then
        vim.env.PATH = fzf_bin .. ":" .. (vim.env.PATH or "")
      end

      local has_bat = vim.fn.executable(bat) == 1
      local preview = has_bat and ("--preview '" .. bat .. " --style=numbers --color=always --line-range=:200 {}'")
        or "--preview 'cat {} | head -200'"

      return {
        fzf_opts = { ["--no-separator"] = "" },
        files = { prompt = "Files> " },
        grep = {
          prompt = "Grep> ",
          rg_opts = ("--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git/*'"),
          preview = preview,
        },
        winopts = {
          border = "rounded",
          preview = {
            border = "rounded",
            layout = "vertical",
            vertical = "down:50%",
          },
        },
      }
    end,
  },
}
