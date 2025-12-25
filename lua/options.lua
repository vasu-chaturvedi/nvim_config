-- lua/options.lua
local opt = vim.o
local fn = vim.fn
local g = vim.g

opt.mouse = ""

-- Cursor + numbers
opt.guicursor = ""
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true
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
opt.updatetime = 250      -- less CPU churn than 50 over SSH
opt.timeoutlen = 400
opt.laststatus = 3
opt.cmdheight = 0
opt.confirm = true
opt.undolevels = 10000

-- Reduce auto-comment continuation noise
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.shortmess:append("c")

-- Files
opt.swapfile = false
opt.backup = false

-- Undo (portable)
local undo_dir = fn.stdpath("state") .. "/undo"
if fn.isdirectory(undo_dir) == 0 then
  fn.mkdir(undo_dir, "p")
end
opt.undodir = undo_dir
opt.undofile = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Force OSC52 as clipboard provider (copy-only)
do
  local ok, osc = pcall(require, "vim.ui.clipboard.osc52")
  if ok then
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
        paste = function()
          return { fn.getreg('"') }
        end,
        cache_enabled = 0,
      }
    end
  end
end
