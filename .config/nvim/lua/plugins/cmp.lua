return {
  {
    "Saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion.ghost_text.enabled = false
      opts.keymap = vim.tbl_extend("keep", opts.keymap, {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-Space>"] = { "select_and_accept", "fallback" },
        ["<CR>"] = {},
      })
    end,
  },
}
