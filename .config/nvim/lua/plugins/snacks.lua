return {
  "folke/snacks.nvim",
  -- dir = "/home/syphdias/git/private/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = false },
    indent = { animate = { enabled = false } },
    scroll = { enabled = false },
    image = {},
    picker = {
      win = {
        input = {
          keys = {
            ["<C-Space>"] = { "select_and_next", mode = { "i", "n" } },
          },
        },
      },
      sources = {
        files = {
          hidden = true,
        },
      },
    },
  },
}
