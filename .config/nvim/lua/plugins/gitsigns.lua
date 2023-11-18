return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },

  -- workaround for https://github.com/LazyVim/LazyVim/issues/1955
  {
    dir = "/home/syphdias/git/private/which-key.nvim",
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
