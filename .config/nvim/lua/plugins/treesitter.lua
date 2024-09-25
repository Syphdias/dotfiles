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

          keymaps = {
            -- capture groups defined in textobjects.scm
            ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
            ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
            ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
            ["r="] = { query = "@assignment.rhs", desc = "Select right hand sidfe of an assignment" },

            -- from https://www.youtube.com/watch?v=CEMPq_r8UYQ but it overwrite defaults from mini.ai
            -- ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
            -- ["ia"] = { query = "@parameter.inter", desc = "Select inter part of a parameter/argument" },
            -- ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
            -- ["ii"] = { query = "@conditional.inter", desc = "Select inter part of a conditional" },
            -- ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
            -- ["il"] = { query = "@loop.inter", desc = "Select inter part of a loop" },
            -- ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
            -- ["if"] = { query = "@call.inter", desc = "Select inter part of a function call" },
            -- ["am"] = { query = "@function.outer", desc = "Select outer part of a function definition" },
            -- ["im"] = { query = "@function.inter", desc = "Select inter part of a function definition" },
            -- ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
            -- ["ic"] = { query = "@class.inter", desc = "Select inter part of a class" },
          },
        },
        -- TODO: Check out https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/4724694bc03ce1148860a46d9d77c3664d8188ab/scripts/minimal_init.lua#L41
        -- https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/nvim-treesitter-text-objects.lua
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
