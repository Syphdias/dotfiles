-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4

-- FIXME: `virtual_text = false` does not take…
-- workaround could be a autocmd — not a proper fix though
vim.diagnostic.config({ virtual_lines = true, virtual_text = false })
