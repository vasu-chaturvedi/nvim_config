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
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("<leader>ld", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					map("<leader>lr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
					map("<leader>li", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>ld", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")

					map("<leader>lds", require("fzf-lua").lsp_document_symbols, "Open Document Symbols")
					map("<leader>lws", require("fzf-lua").lsp_workspace_symbols, "Open Workspace Symbols")
					map("<leader>ltd", require("fzf-lua").lsp_typedefs, "[G]oto [T]ype Definition")

					--map("<leader>lr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					--map("<leader>li", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					--map("<leader>ld", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					--map("<leader>lds", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					--map( "<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					--map("<leader>ltd", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end

					-- Auto import on save for supported filetypes
					if client and client.server_capabilities.codeActionProvider then
						local filetype = vim.bo[event.buf].filetype
						local supported = {
							go = true,
							python = true,
							java = true,
						}
						if supported[filetype] then
							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = event.buf,
								callback = function()
									vim.lsp.buf.code_action({
										context = {
											only = { "source.organizeImports" },
											diagnostics = {},
										},
										apply = true,
									})
								end,
							})
						end
					end
					map("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
					map("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
					--map("<leader>e", require("telescope.builtin").diagnostics, "Show diagnostics in Telescope")
					map("<leader>e", require("fzf-lua").diagnostics_document, "Show diagnostics in fzf-lua")

					map("<leader>ls", vim.lsp.buf.signature_help, "[L]SP [S]ignature Help")
					map("<leader>lh", vim.lsp.buf.hover, "[L]SP [H]over")
				end,
			})
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
					format = function(diagnostic)
						return diagnostic.message
					end,
				},
			})
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local servers = {
				gopls = {
					cmd = { vim.env.NVIM_CONFIG .. "/lsp/gopls/gopls" },
					filetypes = { "go", "gomod" },
					settings = {
						gopls = {
							gofumpt = true,
							completeUnimported = true,
							staticcheck = true,
							analyses = {
								unusedparams = true,
								shadow = true,
							},
						},
					},
				},
				lua_ls = {
					cmd = { vim.env.NVIM_CONFIG .. "/lsp/luals/bin/lua-language-server" },
					settings = {
						Lua = {
							completion = { callSnippet = "Replace" },
						},
					},
				},
				finacle = {
					cmd = { vim.env.NVIM_CONFIG .. "/lsp/finacle/finacle-lsp" },
					filetypes = { "scr" },
				},
			}
			for server_name, server in pairs(servers) do
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				require("lspconfig")[server_name].setup(server)
			end
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.go", "*.py", "*.lua" },
				callback = function(args)
					vim.lsp.buf.format({ bufnr = args.buf })
				end,
			})
		end,
	},
	-- Optionally, add which-key, gitsigns plugins in your plugins folder for even more productivity.
}
