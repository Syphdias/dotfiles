-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to Clipboard" })

-- delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- fix visual block indent interruption
vim.keymap.set({ "i", "n", "v" }, "<C-c>", "<Cmd>noh<CR><Esc>")
-- disable ESC to train C-c
vim.keymap.set({ "i", "n", "v" }, "<Esc>", "<nop>")

-- split navigation with alt
for _, key in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set({ "i", "n", "v" }, "<A-" .. key .. ">", "<cmd>wincmd " .. key .. "<cr>")
end

vim.keymap.set({ "n" }, "<leader>wo", "<c-w>o", { desc = "Close all other windows" })
