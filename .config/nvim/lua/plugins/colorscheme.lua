return {
  "bluz71/vim-nightfly-guicolors",
  -- make sure to load this before all the other plugins
  priority = 1000,
  config = function()
    -- load the colorscheme
    vim.cmd([[colorscheme nightfly]])
  end,
}
