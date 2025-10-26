return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    local wk = require("which-key")
    -- unset well knowns
    local well_knowns = {}
    for i = 1, 9 do
      table.insert(well_knowns, "<leader>" .. i)
    end
    local well_known_table = {}
    for _, well_known in ipairs(well_knowns) do
      table.insert(well_known_table, { well_known, desc = "which_key_ignore" })
    end
    wk.add(well_known_table)
    return opts
  end,
}
