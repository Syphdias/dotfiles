return {
  {
    "ethersync/ethersync",
    keys = { { "<leader>j", "<cmd>EthersyncJumpToCursor<cr>" } },
    config = function(plugin)
      -- Load the plugin from a subfolder:
      vim.opt.rtp:append(plugin.dir .. "/vim-plugin")
      require("lazy.core.loader").packadd(plugin.dir .. "/vim-plugin")
    end,
  },
}
