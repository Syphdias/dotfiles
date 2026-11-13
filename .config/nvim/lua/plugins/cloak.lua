return {
  {
    "laytan/cloak.nvim",
    lazy = false,
    opts = {
      patterns = {
        { file_pattern = ".env*", cloak_pattern = "=.+", replace = nil },
        { file_pattern = "*credential*", cloak_pattern = "=.+", replace = nil },
        { file_pattern = "*secret*", cloak_pattern = "=.+", replace = nil },
      },
    },
  },
}
