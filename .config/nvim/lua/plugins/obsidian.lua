return {
  -- FIXME: ObsidianNew: title as H1
  -- FIXME: ObsidianNew: path should be _inbox unlesse specified otherwise
  -- FIXME: completion for frontmatter (tags, author, links)
  -- FIXME: weird checkboxes while in normal mode
  -- FIXME: picker does not tab completion
  -- FIXME: picker cannot create new (should be shift-enter)
  {
    "obsidian-nvim/obsidian.nvim",
    -- dir = "~/git/private/obsidian.nvim",
    -- version = "*", -- latest release, instead of latest commit
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/Documents/obsidian-palace/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Documents/obsidian-palace/*.md",
    },
    cmd = {
      "Obsidian",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/obsidian-palace/",
        },
      },
      disable_frontmatter = true,
      notes_subdir = "_inbox",
      new_notes_location = "notes_subdir",
      picker = {
        -- name = "telescope.nvim",
        name = "snacks.pick",
      },
      templates = {
        folder = "_meta/templates/",
      },
      -- insert_title = false, -- not implemented
      checkbox = {
        order = { " ", "x" },
      },

      attachments = {
        img_folder = "./media",
      },

      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@param path obsidian.Path|?
      ---@return string|?
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        if title == nil then
          return nil
        end

        local name = title:gsub(":", "–")
        return name
      end,

      -- Optional, customize how note file names are generated given the ID,
      -- target directory, and title.
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>o", group = "Obsidian" },
        { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
        { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New Note" },
        { "<leader>oe", "<cmd>Obsidian new_from_template<cr>", desc = "New Note from Template" },
        { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch" },
        { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today Note" },
        { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday Note" },
        { "<c-cr>", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle Checkbox" },
        { "[[", "<cmd>Obsidian link<cr>", desc = "Link Note" },
      },
    },
  },
}
