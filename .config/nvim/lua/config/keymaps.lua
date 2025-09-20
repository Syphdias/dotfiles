-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to Clipboard" })

-- delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- fix visual block indent interruption
vim.keymap.set({ "i", "n", "v" }, "<C-c>", "<Cmd>noh<CR><Esc>")
-- disable ESC to train C-c
-- vim.keymap.set({ "i", "n", "v" }, "<Esc>", "<nop>")

-- split navigation with alt
for _, key in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set({ "i", "n", "v" }, "<A-" .. key .. ">", "<cmd>wincmd " .. key .. "<cr>")
end

vim.keymap.set({ "n" }, "<leader>wo", "<c-w>o", { desc = "Close all other windows" })

vim.keymap.set({ "n", "v" }, "<leader>gd", function()
  return require("gitsigns").preview_hunk()
end, { desc = "Preview Hunk" })

vim.keymap.set({ "n" }, "<leader>ts", function()
  return Snacks.terminal.toggle()
end, { desc = "Toggle Snack Terminal" })

local diagnostic_level = 4
--@param change number The value to increase or decrease
--@return nil
local function change_diagnostic_level(change)
  local diagnostic_signs = { text = { " ", " ", " ", " " } }
  local diagnostic_virtual_text = { prefix = "●", source = "if_many", spacing = 4 }
  local diagnostic_configs = {
    -- off
    { signs = false, underline = false, virtual_text = false, virtual_lines = false },
    -- +signs
    { signs = diagnostic_signs, underline = false, virtual_text = false, virtual_lines = false },
    -- +underline
    { signs = diagnostic_signs, underline = true, virtual_text = false, virtual_lines = false },
    -- +text at end of line
    { signs = diagnostic_signs, underline = true, virtual_text = diagnostic_virtual_text, virtual_lines = false },
    -- text as multiline
    { signs = diagnostic_signs, underline = true, virtual_text = false, virtual_lines = true },
  }

  if diagnostic_configs[diagnostic_level + change] then
    diagnostic_level = diagnostic_level + change
    vim.diagnostic.config(diagnostic_configs[diagnostic_level])
  end

  if diagnostic_level == 1 then
    print("Diagnostics at minimum")
  elseif diagnostic_level == #diagnostic_configs then
    print("Diagnostics at maximum")
  end
end

vim.keymap.set({ "n" }, "<leader>gK", function()
  change_diagnostic_level(1)
end, { desc = "Increase diagnostics" })

vim.keymap.set({ "n" }, "<leader>gk", function()
  change_diagnostic_level(-1)
end, { desc = "Decrease diagnostics" })

-- FIXME: open Trouble Qlist instead of Qlist after C-q in selector
