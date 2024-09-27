return {
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
