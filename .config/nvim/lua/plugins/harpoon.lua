return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  keys = function(_, keys)
    table.insert(keys, {
      "<C-j>",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Harpoon Next",
    })
    table.insert(keys, {
      "<C-k>",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Harpoon Previous",
    })
    return keys
  end,
}
