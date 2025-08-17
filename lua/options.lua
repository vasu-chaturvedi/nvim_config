local opt = vim.o

opt.guicursor = ""

opt.nu = true
opt.relativenumber = true



opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true
opt.autoindent = true
opt.breakindent = true

opt.ignorecase = true
opt.smartcase = true

opt.wrap = false

vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("XDG_CONFIG_HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8

opt.updatetime = 50

