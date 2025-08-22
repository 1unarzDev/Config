if vim.g.vscode then
  return {}
else
  return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      messages = { view = 'mini' },
      views = {
        mini = {
          position = { col = -1, row = -1 },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup(opts)
      require("notify").setup({
        background_colour = "#000000",
      })

    end,
  }
end
