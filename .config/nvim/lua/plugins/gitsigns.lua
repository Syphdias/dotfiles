return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = false,
    },
  },

  -- workaround for https://github.com/LazyVim/LazyVim/issues/1955
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        mode = { "n", "v" },
        -- group = true,
        ["<leader>gh"] = {
          name = "+hunks",
          [" "] = { "" },
        },
      },
    },
  },
}
