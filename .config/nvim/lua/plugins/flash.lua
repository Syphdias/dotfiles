return {
  "folke/flash.nvim",
  opts = {
    modes = {
      search = {
        -- option to disable flash
        enabled = true,
        -- type ; before labels get active
        search = { incremental = true, trigger = ";" },
      },
    },
  },
  keys = {
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}
