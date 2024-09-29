return {
  {
    "laytan/cloak.nvim",
    cmd = { "CloakEnable", "CloakToggle" },
    opts = {
      patterns = {
        { file_pattern = ".env*", cloak_pattern = "=.+", replace = nil },
        { file_pattern = "credentials", cloak_pattern = "=.+", replace = nil },
      },
    },
  },
}
