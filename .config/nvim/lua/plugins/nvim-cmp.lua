return {
  "hrsh7th/nvim-cmp",

  -- TODO: does that keep the defaults?
  -- TODO: Consider https://www.lazyvim.org/configuration/recipes#supertab
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
    })
  end,
}
