return {
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },

      indent = {
        disable = {
          -- Fixes: https://github.com/nvim-treesitter/nvim-treesitter/issues/1377
          "yaml",
          -- Fixes bullet point indent with gw
          "markdown",
        },
      },

      textobjects = {
        select = {
          enable = true,
          --- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>na"] = "@parameter.inner",
            ["<leader>nm"] = "@function.outer",
          },
          swap_previous = {
            ["<leader>pa"] = "@parameter.inner",
            ["<leader>pm"] = "@function.outer",
          },
        },
      },
      incremental_selection = {
        keymaps = {
          init_selection = "<M-d>",
          node_incremental = "<M-d>",
        },
      },
    },
  },
}
