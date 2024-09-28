return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    local wk = require("which-key")
    -- unset well knowns
    local well_knowns = {
      "<leader>1",
      "<leader>2",
      "<leader>3",
      "<leader>4",
      "<leader>5",
    }
    local well_known_table = {}
    for _, well_known in ipairs(well_knowns) do
      table.insert(well_known_table, { well_known, desc = "which_key_ignore" })
    end
    wk.add(well_known_table)
    return opts
  end,
}
