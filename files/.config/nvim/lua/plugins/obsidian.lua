return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "Second Brain",
        path = "~/Vaults/SecondBrain",
      },
    },

    callbacks = {
      pre_write_note = function(client, note)
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          note:add_field("modified", os.date("%Y-%m-%d %H:%M"))
        end
      end,
    },

    ---@return table
    note_frontmatter_func = function(note)
      local out = { aliases = note.aliases, tags = note.tags, created = note.created, modified = note.modified, connections = note.connections }

      out.created = os.date("%Y-%m-%d %H:%M:%S")
      out.connections = {"[[]]"}

      -- Preserve existing metadata
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      else
        return {}
      end

      out.modified = os.date("%Y-%m-%d %H:%M:%S")

      return out
    end,

    templates = {
        folder = "Templates",
        date_format = os.date("%Y-%m-%d"),
        time_format = os.date("%H:%M:%S"),
    },
  },
}
