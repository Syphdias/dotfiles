return {
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = {
      "BufReadPre /home/syphdias/Documents/obsidian-palace/**.md",
      "BufNewFile /home/syphdias/Documents/obsidian-palace/**.md",
    },
    cmd = {
      "ObsidianNew",
      "ObsidianOpen",
      "ObsidianQuickSwitch",
      "ObsidianFollowLink",
      "ObsidianBacklinks",
      "ObsidianTags",
      "ObsidianToday",
      "ObsidianYesterday",
      "ObsidianTomorrow",
      "ObsidianDailies",
      "ObsidianTemplate",
      "ObsidianSearch",
      "ObsidianLink",
      "ObsidianLinkNew",
      "ObsidianLinks",
      "ObsidianExtractNote",
      "ObsidianWorkspace",
      "ObsidianPasteImg",
      "ObsidianRename",
      "ObsidianToggleCheckbox",
      "ObsidianNewFromTemplate",
      "ObsidianTOC",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      disable_frontmatter = true,
      dir = "~/Documents/obsidian-palace",
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>o", group = "Obsidian" },
        { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "ObsidianQuickSwitch" },
        { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "ObsidianBacklinks" },
        { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "ObsidianToday" },
        { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "ObsidianYesterday" },
        { "<c-cr>", "<cmd>ObsidianToggleCheckbox<cr>", desc = "ObsidianToggleCheckbox" },
        { "[[", "<cmd>ObsidianLink<cr>", desc = "ObsidianLink" },
      },
    },
  },
}
