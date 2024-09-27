return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  event = {
    "BufReadPre /home/syphdias/Documents/obsidian-palace/**.md",
    "BufNewFile /home/syphdias/Documents/obsidian-palace/**.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    disable_frontmatter = true,
    dir = "/home/syphdias/Documents/obsidian-palace",
  },
  -- TODO: gf cannot be rebound because it is set elsewhere
  -- https://github.com/epwalsh/obsidian.nvim/issues/162
}
