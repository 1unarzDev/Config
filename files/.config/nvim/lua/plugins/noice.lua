if vim.g.vscode then
  return {}
else
  return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        messages = { view = 'notify' },
      })
      require("notify").setup({
        background_colour = "#000000",
        placement = "bottom",
        top_down = false,
        timeout = 3000,
      })
    end,
  }
end
