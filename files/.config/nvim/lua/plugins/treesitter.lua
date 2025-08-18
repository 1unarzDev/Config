return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'master',
  build = ':TSUpdate',
  config = function ()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        "bash", "c", "cpp", "html", "javascript", "json", "lua",
        "markdown", "python", "rust", "typescript", "yaml", "java", "go"
      },
      highlight = { 
        enable = true,
        disable = { "markdown" },
      },
    })
  end
}
