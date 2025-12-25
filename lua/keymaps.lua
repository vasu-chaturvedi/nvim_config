vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	if opts.silent == nil then
		opts.silent = true
	end
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function git_root_or_cwd()
	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	return (vim.v.shell_error == 0 and root and #root > 0) and root or vim.loop.cwd()
end

-- General
map("n", "<leader>pv", "<cmd>Ex<CR>", { desc = "Open Netrw (File Explorer)" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
map("n", "J", "mzJ`z", { desc = "Join line without moving cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window navigation & sizing
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase width" })

-- Yank / Paste / Delete
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard (OSC52)" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard (OSC52)" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Location/Quickfix
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next in location list" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev in location list" })
map("n", "[q", "<cmd>cnext<CR>zz", { desc = "Next in quickfix" })
map("n", "]q", "<cmd>cprev<CR>zz", { desc = "Prev in quickfix" })

-- Search/Replace current word
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace word" })

-- Tabs (no conflicts: new tab = <leader>to)
map("n", "<leader>to", ":tabnew<CR>", { desc = "New Tab" })
map("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" })
map("n", "<leader>tp", ":tabprev<CR>", { desc = "Previous Tab" })
map("n", "<leader>tn", ":tabnext<CR>", { desc = "Next Tab" })

-- Splits
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical Split" })
map("n", "<leader>sh", ":split<CR>", { desc = "Horizontal Split" })
map("n", "<leader>cw", ":close<CR>", { desc = "Close Window" })

-- BufferLine with fallback
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })
