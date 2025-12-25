-- lua/keymaps.lua
vim.g.have_nerd_font = true

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  if opts.silent == nil then
    opts.silent = true
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function has(mod)
  return pcall(require, mod)
end

local function with(mod, fn, fallback)
  return function(...)
    local ok, m = pcall(require, mod)
    if ok and m then
      return fn(m, ...)
    end
    if fallback then
      return fallback(...)
    end
  end
end

local function git_root_or_cwd()
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  return (vim.v.shell_error == 0 and root and #root > 0) and root or (vim.uv or vim.loop).cwd()
end

-- ----------------------------
-- General
-- ----------------------------
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
map("n", "J", "mzJ`z", { desc = "Join line without moving cursor" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center" })
map("n", "n", "nzzzv", { desc = "Next search result and center" })
map("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Terminal mode escape (works even without toggleterm)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ----------------------------
-- Window navigation & sizing
-- ----------------------------
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase width" })

-- ----------------------------
-- Yank / Paste / Delete
-- ----------------------------
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard (OSC52 provider)" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard (OSC52 provider)" })
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking selection" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to blackhole" })

-- ----------------------------
-- Diagnostics
-- ----------------------------
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- ----------------------------
-- Location/Quickfix
-- ----------------------------
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next in location list" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Prev in location list" })
map("n", "[q", "<cmd>cnext<CR>zz", { desc = "Next in quickfix" })
map("n", "]q", "<cmd>cprev<CR>zz", { desc = "Prev in quickfix" })

-- ----------------------------
-- Search/Replace current word
-- ----------------------------
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search & replace word" })

-- ----------------------------
-- Tabs / Splits / Buffers
-- ----------------------------
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New Tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close Tab" })
map("n", "<leader>tp", "<cmd>tabprev<CR>", { desc = "Previous Tab" })
map("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next Tab" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical Split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal Split" })
map("n", "<leader>cw", "<cmd>close<CR>", { desc = "Close Window" })

map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous Buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete Buffer" })

-- =====================================================================
-- AUTO-DETECT PLUGIN KEYMAPS
-- =====================================================================

-- ----------------------------
-- Oil (preferred) / netrw fallback
-- ----------------------------
map("n", "<leader>pv", function()
  if has("oil") then
    vim.cmd("Oil")
  else
    vim.cmd("Ex")
  end
end, { desc = "File explorer (Oil / netrw fallback)" })

map("n", "-", function()
  if has("oil") then
    vim.cmd("Oil")
  else
    -- fallback: open netrw in current dir
    vim.cmd("Ex")
  end
end, { desc = "Open parent (Oil / netrw fallback)" })

-- ----------------------------
-- ToggleTerm / builtin terminal fallback
-- ----------------------------
local function open_builtin_term(direction)
  if direction == "vertical" then
    vim.cmd("vsplit | terminal")
  elseif direction == "horizontal" then
    vim.cmd("split | terminal")
  else
    vim.cmd("terminal")
  end
end

map("n", "<leader>tt", function()
  if vim.fn.exists(":ToggleTerm") == 2 then
    vim.cmd("ToggleTerm")
  else
    open_builtin_term("float")
  end
end, { desc = "Terminal (ToggleTerm / builtin fallback)" })

map("n", "<leader>tf", function()
  if vim.fn.exists(":ToggleTerm") == 2 then
    vim.cmd("ToggleTerm direction=float")
  else
    open_builtin_term("float")
  end
end, { desc = "Floating terminal (ToggleTerm / builtin fallback)" })

map("n", "<leader>th", function()
  if vim.fn.exists(":ToggleTerm") == 2 then
    vim.cmd("ToggleTerm direction=horizontal")
  else
    open_builtin_term("horizontal")
  end
end, { desc = "Horizontal terminal (ToggleTerm / builtin fallback)" })

map("n", "<leader>tv", function()
  if vim.fn.exists(":ToggleTerm") == 2 then
    vim.cmd("ToggleTerm direction=vertical")
  else
    open_builtin_term("vertical")
  end
end, { desc = "Vertical terminal (ToggleTerm / builtin fallback)" })

-- ----------------------------
-- fzf-lua / builtin fallback
-- ----------------------------
local function fzf_or_builtin(fzf_fn, builtin_fn)
  return function()
    local ok, fzf = pcall(require, "fzf-lua")
    if ok and fzf and type(fzf[fzf_fn]) == "function" then
      return fzf[fzf_fn]()
    end
    return builtin_fn()
  end
end

-- Find files
map("n", "<leader>ff", fzf_or_builtin("files", function()
  vim.cmd("edit " .. vim.fn.fnameescape(vim.fn.getcwd()))
end), { desc = "Find files (fzf-lua / fallback)" })

-- Recent files
map("n", "<leader>fr", fzf_or_builtin("oldfiles", function()
  vim.cmd("browse oldfiles")
end), { desc = "Recent files (fzf-lua / fallback)" })

-- Buffers
map("n", "<leader>fb", fzf_or_builtin("buffers", function()
  vim.cmd("ls")
end), { desc = "Buffers (fzf-lua / fallback)" })

-- Grep
map("n", "<leader>fg", fzf_or_builtin("live_grep", function()
  vim.ui.input({ prompt = "Grep pattern: " }, function(pat)
    if not pat or pat == "" then
      return
    end
    -- Minimal builtin fallback: vimgrep in cwd
    vim.cmd(("vimgrep /%s/j **/*"):format(pat))
    vim.cmd("copen")
  end)
end), { desc = "Live grep (fzf-lua / fallback)" })

-- Grep word under cursor
map("n", "<leader>fw", fzf_or_builtin("grep_cword", function()
  local w = vim.fn.expand("<cword>")
  if w and w ~= "" then
    vim.cmd(("vimgrep /\\V%s/j **/*"):format(w))
    vim.cmd("copen")
  end
end), { desc = "Grep word (fzf-lua / fallback)" })

-- Help tags / Commands / Keymaps
map("n", "<leader>fh", fzf_or_builtin("help_tags", function() vim.cmd("help") end), { desc = "Help tags (fzf-lua / fallback)" })
map("n", "<leader>fc", fzf_or_builtin("commands", function() vim.cmd("command") end), { desc = "Commands (fzf-lua / fallback)" })
map("n", "<leader>fk", fzf_or_builtin("keymaps", function() vim.cmd("map") end), { desc = "Keymaps (fzf-lua / fallback)" })

-- Git pickers (only if fzf-lua is present; otherwise no-op message)
map("n", "<leader>gf", with("fzf-lua", function(fzf) fzf.git_files({ cwd = git_root_or_cwd() }) end, function()
  vim.notify("fzf-lua not installed: git_files unavailable", vim.log.levels.WARN)
end), { desc = "Git files (fzf-lua)" })

map("n", "<leader>gs", with("fzf-lua", function(fzf) fzf.git_status({ cwd = git_root_or_cwd() }) end, function()
  vim.notify("fzf-lua not installed: git_status unavailable", vim.log.levels.WARN)
end), { desc = "Git status (fzf-lua)" })
