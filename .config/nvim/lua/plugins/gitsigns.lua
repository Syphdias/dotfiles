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
          -- https://github.com/LazyVim/LazyVim/discussions/2887#discussioncomment-8962181
          ["🚫"] = "which_key_ignore",
        },
      },
    },
  },
}
