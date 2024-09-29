return {
  {
    -- "CRAG666/code_runner.nvim",
    dir = "~/git/private/code_runner.nvim",
    config = true,
    keys = {
      { "<leader>pp", "<cmd>RunProject<cr>", desc = "Execute Code Runner project command" },
    },
    opts = {
      focus = false,
      term = {
        size = 30,
      },
      project = SafeRequire("...code_runner_projects"),
    },
  },

  {
    "CRAG666/betterTerm.nvim",
    keys = {
      {
        "<leader>tt",
        function()
          require("betterTerm").open()
        end,
        { desc = "Open terminal" },
      },
    },
    opts = {
      position = "bot",
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>p", group = "Project" },
        { "<leader>t", group = "Terminal" },
      },
    },
  },
}
