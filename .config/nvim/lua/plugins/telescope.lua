return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },

  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-k>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
          ["<C-j>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<C-q>"] = function(...)
            return require("telescope.actions").send_selected_to_qflist(...)
              + require("telescope.actions").open_qflist(...)
          end,
        },
      },
    },
  },
}
