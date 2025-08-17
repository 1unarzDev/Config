-- Help
local map = vim.keymap.set

-- Plugins
require('config.lazy')
require('lazy').setup('plugins')

-- System clipboard
vim.opt.clipboard = "unnamedplus"

-- Bindings
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "

-- Lines
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- Tabs
vim.opt.tabstop = 4 -- Number of spaces a tab character represents
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindentation
vim.opt.expandtab = true -- Convert tabs to spaces

map("n", "<Tab>", ">>",  opts)
map("n", "<S-Tab>", "<<",  opts)
map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)
map("i", "<Tab>", "<C-t>", opts)
map("i", "<S-Tab>", "<C-d>", opts)

-- Panel Movement
map("n", "<C-h>", "<C-w>h") -- (Left)
map("n", "<C-j>", "<C-w>j") -- (Up)
map("n", "<C-k>", "<C-w>k") -- (Down)
map("n", "<C-l>", "<C-w>l") -- (Right)

-- Fuzzy finder
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope Find Files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope Live Grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Telescope Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope Help Tags" })

-- VimTeX
map("n", "<leader>co", "<cmd>VimtexCompile<cr>")
map("n", "<leader>cv", "<cmd>VimtexView<cr>")
map("n", "<leader>cq", "<cmd>VimtexStop<cr>")
vim.cmd("autocmd BufEnter *.pdf silent !zathura '%' &")

-- Color highlights
vim.opt.termguicolors = true
require('nvim-highlight-colors').setup({})

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Obsidian
vim.opt.conceallevel = 1

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()

map("n", "<leader>ha", function() harpoon:list():add() end)
map("n", "<leader>hr", function() harpoon:list():remove() end)
map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
