return {
  "goolord/alpha-nvim",

  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    -- move "Restore Session" to the top of the list
    local restore_button = table.remove(dashboard.section.buttons.val, 6)
    table.insert(dashboard.section.buttons.val, 1, restore_button)

    return dashboard
  end,
}
