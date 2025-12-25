return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- diagnostics: stable defaults
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(d)
            local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code)
            if code then
              return string.format("%s (%s)", d.message, code)
            end
            return d.message
          end,
        },
      })

      -- Rounded UI to match Noice etc.
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- fzf-lua is lazy-loaded: use it if present, otherwise fallback to builtin LSP actions.
      local function fzf_or_fallback(fzf_fn, fallback_fn)
        return function()
          local ok, fzf = pcall(require, "fzf-lua")
          if ok and fzf and type(fzf[fzf_fn]) == "function" then
            return fzf[fzf_fn]()
          end
          return fallback_fn()
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", fzf_or_fallback("lsp_definitions", vim.lsp.buf.definition), "Go to definition")
          map("gr", fzf_or_fallback("lsp_references", vim.lsp.buf.references), "References")
          map("gI", fzf_or_fallback("lsp_implementations", vim.lsp.buf.implementation), "Go to implementation")
          map("<leader>D", fzf_or_fallback("lsp_typedefs", vim.lsp.buf.type_definition), "Type definition")
          map("<leader>ds", fzf_or_fallback("lsp_document_symbols", vim.lsp.buf.document_symbol), "Document symbols")
          map("<leader>ws", fzf_or_fallback("lsp_workspace_symbols", vim.lsp.buf.workspace_symbol), "Workspace symbols")

          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("K", vim.lsp.buf.hover, "Hover docs")

          -- Document highlight (if supported)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = hl_group,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = hl_group,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(ev)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = ev.buf })
              end,
            })
          end

          -- Go: organize imports on save (gopls)
          if client and client.name == "gopls" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = event.buf,
              callback = function()
                local params = vim.lsp.util.make_range_params()
                params.context = { only = { "source.organizeImports" } }
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 2000)
                for _, res in pairs(result or {}) do
                  for _, r in pairs(res.result or {}) do
                    if r.edit then
                      vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
                    elseif r.command then
                      vim.lsp.buf.execute_command(r.command)
                    end
                  end
                end
              end,
              desc = "Go: organize imports",
            })
          end
        end,
      })

      -- --------- Offline-friendly server cmd resolver ----------
      local BIN = vim.env.NVIM_CONFIG and (vim.env.NVIM_CONFIG .. "/lsp") or (vim.fn.stdpath("config") .. "/lsp")

      local function cmd_or_warn(candidates, _server_name)
        for _, c in ipairs(candidates) do
          if vim.fn.executable(c) == 1 then
            return { c }
          end
        end
        return nil
      end

      local missing = {}

      local servers = {
        gopls = {
          cmd = cmd_or_warn({ BIN .. "/gopls/gopls", BIN .. "/gopls" }, "gopls"),
          filetypes = { "go", "gomod" },
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              completeUnimported = true,
              analyses = { unusedparams = true, shadow = true },
            },
          },
        },

        lua_ls = {
          cmd = cmd_or_warn({
            BIN .. "/lua-language-server/bin/lua-language-server",
            BIN .. "/luals/bin/lua-language-server",
            BIN .. "/lua_ls/bin/lua-language-server",
          }, "lua_ls"),
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim" } },
            },
          },
        },

        bashls = { cmd = cmd_or_warn({ BIN .. "/bash-language-server/bin/bash-language-server" }, "bashls") },
        pyright = { cmd = cmd_or_warn({ BIN .. "/pyright-langserver", BIN .. "/pyright-langserver.cmd" }, "pyright") },
        jsonls = { cmd = cmd_or_warn({ BIN .. "/vscode-json-language-server/bin/vscode-json-language-server" }, "jsonls") },
        html = { cmd = cmd_or_warn({ BIN .. "/vscode-html-language-server/bin/vscode-html-language-server" }, "html") },
        yamlls = { cmd = cmd_or_warn({ BIN .. "/yaml-language-server/bin/yaml-language-server" }, "yamlls") },
        marksman = { cmd = cmd_or_warn({ BIN .. "/marksman" }, "marksman") },
        clangd = { cmd = cmd_or_warn({ BIN .. "/clangd/bin/clangd", BIN .. "/clangd" }, "clangd") },
        sqlls = { cmd = cmd_or_warn({ BIN .. "/sql-language-server/bin/sql-language-server" }, "sqlls") },

        -- jdtls is usually started per-project with a separate setup.
        -- jdtls = { cmd = cmd_or_warn({ BIN .. "/jdtls/bin/jdtls" }, "jdtls") },
      }

      for name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        if cfg.cmd == nil then
          table.insert(missing, name)
        else
          require("lspconfig")[name].setup(cfg)
        end
      end

      if #missing > 0 then
        vim.schedule(function()
          vim.notify(
            ("LSP binaries not found under %s for: %s"):format(BIN, table.concat(missing, ", ")),
            vim.log.levels.WARN
          )
        end)
      end
    end,
  },
}
