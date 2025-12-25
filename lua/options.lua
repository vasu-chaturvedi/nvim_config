-- Neovim options (v0.11.x), optimized for SSH/PuTTY + ARCON
local opt = vim.o
local fn = vim.fn
local g = vim.g

opt.mouse = ""
-- Cursor + numbers
opt.guicursor = "" -- block cursor everywhere
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true -- used if/when wrap=true
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI/UX
opt.termguicolors = true
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.updatetime = 50 -- faster CursorHold
opt.timeoutlen = 400 -- snappier mappings
opt.laststatus = 3 -- global statusline
opt.cmdheight = 0 -- minimal cmdline (0 => auto)

-- Files
opt.swapfile = false
opt.backup = false

-- Use Neovim's state dir for undo (portable + correct)
local undo_dir = fn.stdpath("state") .. "/undo"
if fn.isdirectory(undo_dir) == 0 then
	fn.mkdir(undo_dir, "p")
end
opt.undodir = undo_dir
opt.undofile = true

-- Clipboard
opt.clipboard = "unnamedplus" -- integrate with system/OSC52

-- Force OSC52 as the clipboard provider (best for PuTTY via ARCON)
-- We avoid OSC52 "paste" reads (terminals rarely support read-back).
do
	local ok, osc = pcall(require, "vim.ui.clipboard.osc52")
	if ok then
		-- Get a copy() function from the module regardless of module shape.
		local provider_tbl = nil
		local copy_fn = nil

		if type(osc) == "table" then
			if type(osc.copy) == "function" and type(osc.paste) == "function" then
				provider_tbl = osc
			elseif type(osc.new) == "function" then
				local inst = osc.new()
				if type(inst) == "table" and type(inst.copy) == "function" then
					provider_tbl = inst
				end
			end
		elseif type(osc) == "function" then
			local inst = osc()
			if type(inst) == "table" and type(inst.copy) == "function" then
				provider_tbl = inst
			end
		end

		if provider_tbl then
			copy_fn = provider_tbl.copy
		end

		if type(copy_fn) == "function" then
			g.clipboard = {
				name = "osc52-only-copy",
				copy = { ["+"] = copy_fn, ["*"] = copy_fn },
				-- Fallback paste: use Neovim's default unnamed register content
				paste = function()
					return { fn.getreg('"') }
				end,
				cache_enabled = 0,
			}
		end
	end
end
