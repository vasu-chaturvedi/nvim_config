-- init.lua (Neovim 0.11.5)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  -- In offline environments, prefer manual install.
  if vim.fn.executable("git") == 1 then
    -- If your environment has internet, this will work; otherwise you'll get a clear error.
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      error(
        "lazy.nvim not found and clone failed.\n"
          .. "Manual install required (offline): copy lazy.nvim to:\n  "
          .. lazypath
          .. "\n\nClone output:\n"
          .. out
      )
    end
  else
    error("lazy.nvim not found and git is not available! Please copy it manually to: " .. lazypath)
  end
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
