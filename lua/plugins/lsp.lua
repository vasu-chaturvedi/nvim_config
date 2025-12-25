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
						return d.message
					end,
				},
			})

			-- LSP attach: maps + lightweight features
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- navigation (fzf-lua)
					map("<leader>ld", require("fzf-lua").lsp_definitions, "[L]SP [D]efinition")
					map("<leader>lD", vim.lsp.buf.declaration, "[L]SP [D]eclaration")
					map("<leader>lr", require("fzf-lua").lsp_references, "[L]SP [R]eferences")
					map("<leader>li", require("fzf-lua").lsp_implementations, "[L]SP [I]mplementation")
					map("<leader>ltd", require("fzf-lua").lsp_typedefs, "[L]SP [T]ype [D]ef")
					map("<leader>lds", require("fzf-lua").lsp_document_symbols, "Doc Symbols")
					map("<leader>lws", require("fzf-lua").lsp_workspace_symbols, "Workspace Symbols")

					-- actions & help
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "Code [A]ction", { "n", "x" })
					map("<leader>ls", vim.lsp.buf.signature_help, "[L]SP [S]ignature")
					map("<leader>lh", vim.lsp.buf.hover, "[L]SP [H]over")
					map("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
					map("]d", vim.diagnostic.goto_next, "Next diagnostic")
					map("<leader>e", require("fzf-lua").diagnostics_document, "Diagnostics (buffer)")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local function supports(method)
						return client and client:supports_method(method, event.buf)
					end

					-- document highlight if supported
					if supports(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local hl = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = hl,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = hl,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(ev)
								pcall(vim.lsp.buf.clear_references)
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = ev.buf })
							end,
						})
					end

					-- inlay hints toggle if supported
					if supports(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end

					-- optional: organize imports on save (Go only)
					if client and client.name == "gopls" and client.server_capabilities.codeActionProvider then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = event.buf,
							callback = function()
								vim.lsp.buf.code_action({
									context = { only = { "source.organizeImports" }, diagnostics = {} },
									apply = true,
								})
							end,
						})
					end
				end,
			})

			-- capabilities from Blink
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- offline-friendly cmd resolver
			local function exe(p)
				return vim.fn.executable(p) == 1
			end
			local function cmd_or_warn(path_list, name)
				for _, p in ipairs(path_list) do
					if exe(p) then
						return { p }
					end
				end
				vim.schedule(function()
					vim.notify(("LSP binary for %s not found in NVIM_CONFIG/lsp"):format(name), vim.log.levels.WARN)
				end)
				return nil
			end

			local BIN = vim.env.NVIM_CONFIG .. "/lsp"
			local servers = {
				gopls = {
					cmd = cmd_or_warn({
						BIN .. "/gopls/gopls",
						BIN .. "/gopls", -- fallback if you keep it flat
					}, "gopls"),
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
					}, "lua-language-server"),
					settings = {
						Lua = { completion = { callSnippet = "Replace" } },
					},
				},
				--finacle = {
				--	cmd = cmd_or_warn({ BIN .. "/finacle/finacle-lsp" }, "finacle-lsp"),
				--	filetypes = { "scr" },
				--},
			}

			for name, cfg in pairs(servers) do
				cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
				require("lspconfig")[name].setup(cfg)
			end

			-- If you use Conform for on-save formatting, REMOVE this block:
			-- (otherwise it can double-format)
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			--   pattern = { "*.go", "*.py", "*.lua" },
			--   callback = function(args) vim.lsp.buf.format({ bufnr = args.buf }) end,
			-- })
		end,
	},
}
