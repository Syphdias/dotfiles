return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- do not preview for completion
      opts.completion.ghost_text.enabled = false

      -- casing is important for keymap merge. The preset uses <C-space>; if we
      -- use <C-Space> here, we sometimes get one behavior and sometimes the
      -- other (this stole an hour of my life)
      opts.keymap = vim.tbl_extend("force", opts.keymap, {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-space>"] = { "select_and_accept", "show", "fallback" },
        ["<CR>"] = {},
      })
    end,
  },
}
