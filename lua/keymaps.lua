vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- General Keymaps
local general = {
    { mode = "n", lhs = "<leader>pv", rhs = vim.cmd.Ex,            opts = { desc = "Open Netrw (File Explorer)" } },
    { mode = "n", lhs = "<Esc>",      rhs = "<cmd>nohlsearch<CR>", opts = { desc = "Clear search highlights" } },
    { mode = "v", lhs = "J",          rhs = ":m '>+1<CR>gv=gv",    opts = { desc = "Move selected lines down" } },
    { mode = "v", lhs = "K",          rhs = ":m '<-2<CR>gv=gv",    opts = { desc = "Move selected lines up" } },
    { mode = "n", lhs = "J",          rhs = "mzJ`z",               opts = { desc = "Join line without moving cursor" } },
    { mode = "n", lhs = "<C-d>",      rhs = "<C-d>zz",             opts = { desc = "Scroll half page down and center" } },
    { mode = "n", lhs = "<C-u>",      rhs = "<C-u>zz",             opts = { desc = "Scroll half page up and center" } },
    { mode = "n", lhs = "n",          rhs = "nzzzv",               opts = { desc = "Next search result and center" } },
    { mode = "n", lhs = "N",          rhs = "Nzzzv",               opts = { desc = "Previous search result and center" } },
    { mode = "t", lhs = "<Esc><Esc>", rhs = "<C-\\><C-n>",         opts = { desc = "Exit terminal mode" } },
}

-- Window Navigation
local window_nav = {
    { mode = "n", lhs = "<C-h>",     rhs = "<C-w><C-h>",              opts = { desc = "Move focus to the left window" } },
    { mode = "n", lhs = "<C-l>",     rhs = "<C-w><C-l>",              opts = { desc = "Move focus to the right window" } },
    { mode = "n", lhs = "<C-j>",     rhs = "<C-w><C-j>",              opts = { desc = "Move focus to the lower window" } },
    { mode = "n", lhs = "<C-k>",     rhs = "<C-w><C-k>",              opts = { desc = "Move focus to the upper window" } },
    { mode = "n", lhs = "<C-Up>",    rhs = ":resize +2<CR>",          opts = { desc = "Increase window height" } },
    { mode = "n", lhs = "<C-Down>",  rhs = ":resize -2<CR>",          opts = { desc = "Decrease window height" } },
    { mode = "n", lhs = "<C-Left>",  rhs = ":vertical resize -2<CR>", opts = { desc = "Decrease window width" } },
    { mode = "n", lhs = "<C-Right>", rhs = ":vertical resize +2<CR>", opts = { desc = "Increase window width" } },
}

-- Yank/Paste/Delete
local clipboard = {
    { mode = "x",          lhs = "<leader>p", rhs = [["_dP]], opts = { desc = "Paste without yanking current selection" } },
    { mode = { "n", "v" }, lhs = "<leader>y", rhs = [["+y]],  opts = { desc = "Yank to system clipboard" } },
    { mode = "n",          lhs = "<leader>Y", rhs = [["+Y]],  opts = { desc = "Yank current line to system clipboard" } },
    { mode = { "n", "v" }, lhs = "<leader>d", rhs = [["_d]],  opts = { desc = "Delete to blackhole register" } },
}

-- Diagnostics
local diagnostics = {
    { mode = "n", lhs = "[d", rhs = vim.diagnostic.goto_prev, opts = { desc = "Go to previous diagnostic" } },
    { mode = "n", lhs = "]d", rhs = vim.diagnostic.goto_next, opts = { desc = "Go to next diagnostic" } },
}

-- Location/Quickfix List
local loclist = {
    { mode = "n", lhs = "<leader>k", rhs = "<cmd>lnext<CR>zz", opts = { desc = "Next item in location list" } },
    { mode = "n", lhs = "<leader>j", rhs = "<cmd>lprev<CR>zz", opts = { desc = "Previous item in location list" } },
    { mode = "n", lhs = "[q",        rhs = "<cmd>cnext<CR>zz", opts = { desc = "Next item in quickfix list" } },
    { mode = "n", lhs = "]q",        rhs = "<cmd>cprev<CR>zz", opts = { desc = "Previous item in quickfix list" } },
}

-- Search/Replace
local search = {
    {
        mode = "n",
        lhs = "<leader>s",
        rhs = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
        opts = { desc = "Search and replace current word" },
    },
}

-- File/Buffer/Tab/Window Management
local file_nav = {
    {
        mode = "n",
        lhs = "<leader>x",
        rhs = "<cmd>!chmod +x %<CR>",
        opts = { silent = true, desc = "Make current file executable" },
    },
    { mode = "n", lhs = "<leader>tn", rhs = ":tabnew<CR>",                  opts = { desc = "New Tab" } },
    { mode = "n", lhs = "<leader>tc", rhs = ":tabclose<CR>",                opts = { desc = "Close Tab" } },
    { mode = "n", lhs = "<leader>tp", rhs = ":tabprev<CR>",                 opts = { desc = "Previous Tab" } },
    { mode = "n", lhs = "<leader>tn", rhs = ":tabnext<CR>",                 opts = { desc = "Next Tab" } },
    { mode = "n", lhs = "<leader>sv", rhs = ":vsplit<CR>",                  opts = { desc = "Vertical Split" } },
    { mode = "n", lhs = "<leader>sh", rhs = ":split<CR>",                   opts = { desc = "Horizontal Split" } },
    { mode = "n", lhs = "<leader>cw", rhs = ":close<CR>",                   opts = { desc = "Close Window" } },
    { mode = "n", lhs = "<leader>bn", rhs = "<cmd>BufferLineCycleNext<CR>", opts = { desc = "Next Buffer" } },
    { mode = "n", lhs = "<leader>bp", rhs = "<cmd>BufferLineCyclePrev<CR>", opts = { desc = "Previous Buffer" } },
    { mode = "n", lhs = "<leader>e",  rhs = "<cmd>Oil<CR>",                 opts = { desc = "Open File Explorer (Oil)" } },
}

-- Noice
local noice = {
    { mode = "n", lhs = "<leader>nd", rhs = "<cmd>NoiceDismiss<CR>", opts = { desc = "Dismiss all Noice messages" } },
}

vim.keymap.set("n", "<leader>gg", function()
    local Terminal = require("toggleterm.terminal").Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
    lazygit:toggle()
end, { desc = "Open LazyGit" })
-- Register all keymaps
local function register(maps)
    for _, map in ipairs(maps) do
        vim.keymap.set(map.mode, map.lhs, map.rhs, map.opts)
    end
end

register(general)
register(window_nav)
register(clipboard)
register(diagnostics)
register(loclist)
register(search)
register(file_nav)
register(noice)
