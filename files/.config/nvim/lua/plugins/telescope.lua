if vim.g.vscode then
  return {}
else
  return {
      'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
  }
end
