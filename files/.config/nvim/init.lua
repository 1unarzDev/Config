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
vim.opt.signcolumn = "number"

-- Tabs
vim.opt.tabstop = 4 -- Number of spaces a tab character represents
vim.opt.shiftwidth = 4 -- Number of spaces to use for autoindentation
vim.opt.expandtab = true -- Convert tabs to spaces

vim.keymap.set("n", "<Tab>", ">>",  opts)
vim.keymap.set("n", "<S-Tab>", "<<",  opts)
vim.keymap.set("v", "<Tab>", ">gv", opts)
vim.keymap.set("v", "<S-Tab>", "<gv", opts)
vim.keymap.set("i", "<Tab>", "<C-t>", opts)
vim.keymap.set("i", "<S-Tab>", "<C-d>", opts)

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fq", builtin.live_grep, {})

-- Tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

-- Competitest
require('competitest').setup {
	local_config_file_name = ".competitest.lua",

	floating_border = "rounded",
	floating_border_highlight = "FloatBorder",
	picker_ui = {
		width = 0.2,
		height = 0.3,
		mappings = {
			focus_next = { "j", "<down>", "<Tab>" },
			focus_prev = { "k", "<up>", "<S-Tab>" },
			close = { "<esc>", "<C-c>", "q", "Q" },
			submit = "<cr>",
		},
	},
	editor_ui = {
		popup_width = 0.4,
		popup_height = 0.6,
		show_nu = true,
		show_rnu = false,
		normal_mode_mappings = {
			switch_window = { "<C-h>", "<C-l>", "<C-i>" },
			save_and_close = "<C-s>",
			cancel = { "q", "Q" },
		},
		insert_mode_mappings = {
			switch_window = { "<C-h>", "<C-l>", "<C-i>" },
			save_and_close = "<C-s>",
			cancel = "<C-q>",
		},
	},
	runner_ui = {
		interface = "popup",
		selector_show_nu = false,
		selector_show_rnu = false,
		show_nu = true,
		show_rnu = false,
		mappings = {
			run_again = "R",
			run_all_again = "<C-r>",
			kill = "K",
			kill_all = "<C-k>",
			view_input = { "i", "I" },
			view_output = { "a", "A" },
			view_stdout = { "o", "O" },
			view_stderr = { "e", "E" },
			toggle_diff = { "d", "D" },
			close = { "q", "Q" },
		},
		viewer = {
			width = 0.5,
			height = 0.5,
			show_nu = true,
			show_rnu = false,
			open_when_compilation_fails = true,
		},
	},
	popup_ui = {
		total_width = 0.8,
		total_height = 0.8,
		layout = {
			{ 4, "tc" },
			{ 5, { { 1, "so" }, { 1, "si" } } },
			{ 5, { { 1, "eo" }, { 1, "se" } } },
		},
	},
	split_ui = {
		position = "right",
		relative_to_editor = true,
		total_width = 0.3,
		vertical_layout = {
			{ 1, "tc" },
			{ 1, { { 1, "so" }, { 1, "eo" } } },
			{ 1, { { 1, "si" }, { 1, "se" } } },
		},
		total_height = 0.4,
		horizontal_layout = {
			{ 2, "tc" },
			{ 3, { { 1, "so" }, { 1, "si" } } },
			{ 3, { { 1, "eo" }, { 1, "se" } } },
		},
	},

	save_current_file = true,
	save_all_files = false,
	compile_directory = ".",
	compile_command = {
		c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
		cpp = { exec = "g++", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
		rust = { exec = "rustc", args = { "$(FNAME)" } },
		java = { exec = "javac", args = { "$(FNAME)" } },
	},
	running_directory = ".",
	run_command = {
		c = { exec = "./$(FNOEXT)" },
		cpp = { exec = "./$(FNOEXT)" },
		rust = { exec = "./$(FNOEXT)" },
		python = { exec = "python", args = { "$(FNAME)" } },
		java = { exec = "java", args = { "$(FNOEXT)" } },
	},
	multiple_testing = -1,
	maximum_time = 5000,
	output_compare_method = "squish",
	view_output_diff = false,

	testcases_directory = ".",
	testcases_use_single_file = false,
	testcases_auto_detect_storage = true,
	testcases_single_file_format = "$(FNOEXT).testcases",
	testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
	testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

	companion_port = 27121,
	receive_print_message = true,
	start_receiving_persistently_on_setup = false,
	template_file = false,
	evaluate_template_modifiers = false,
	date_format = "%c",
	received_files_extension = "cpp",
	received_problems_path = "$(CWD)/$(PROBLEM).$(FEXT)",
	received_problems_prompt_path = true,
	received_contests_directory = "$(CWD)",
	received_contests_problems_path = "$(PROBLEM).$(FEXT)",
	received_contests_prompt_directory = true,
	received_contests_prompt_extension = true,
	open_received_problems = true,
	open_received_contests = true,
	replace_received_testcases = false,
}
