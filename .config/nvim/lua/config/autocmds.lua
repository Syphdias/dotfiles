-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- textwidth for gitcommit and markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.textwidth = 72
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

-- fix spellchecking language(s)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spl = "en,de_20"
  end,
})

-- filetypes that use indentation of 2
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- autoreload kitty config edits
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*/kitty.conf" },
  command = "silent !kill -SIGUSR1 $(pgrep kitty)",
})

-- Disable re-reading file descriptors that will then be gone
vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "/proc/*/fd/*" },
  callback = function()
    vim.opt_local.buftype = "nofile"
  end,
})

-- show quotes in JSON files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
