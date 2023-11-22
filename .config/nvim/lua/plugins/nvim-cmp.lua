return {
  "hrsh7th/nvim-cmp",

  -- https://www.lazyvim.org/configuration/recipes#supertab
  dependencies = {
    "hrsh7th/cmp-emoji",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")

    -- Map Ctrl-j/k to select completion
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      -- complete() or confirm()? Currently used for snippets and treesitter
      -- ["<C-Space>"] = cmp.confirm(),
    })
  end,
}
