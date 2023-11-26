return {
  {
    -- marking and jumping
    -- TODO: keybinds
    "ThePrimeagen/harpoon",
    keys = {
      { "<leader>hm", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Mark file with harpoon" }, -- p uses <leader>a
      { "<leader>hu", "<cmd>lua require('harpoon.mark').rm_file()<cr>", desc = "Unmark file with harpoon" }, -- p uses <leader>a
      { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Go to next harpoon mark" },
      { "<c-j>", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Go to next harpoon mark" },
      { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Go to previous harpoon mark" },
      { "<c-k>", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Go to previous harpoon mark" },
      { "<leader>ha", "<cmd>Telescope harpoon marks<cr>", desc = "Show harpoon marks" }, -- p uses <leader>e
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>h"] = { name = "+harpoon" },
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      presets = {
        -- TODO: slightly lower Cmdline
        -- command_palette = false,
      },
    },
  },
}
