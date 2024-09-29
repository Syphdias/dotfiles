return {
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
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

      -- Fixes: https://github.com/nvim-treesitter/nvim-treesitter/issues/1377
      indent = {
        disable = { "yaml" },
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
    ---@param opts TSConfig
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
      end
      require("nvim-treesitter.configs").setup(opts)

      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/655
      vim.treesitter.language.register("bash", "zsh")
    end,
  },
}
