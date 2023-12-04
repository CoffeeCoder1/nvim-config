---- VIM Setup ----
vim.api.nvim_command('filetype plugin indent off')

---- Editor settings ----
vim.opt.termguicolors = true
if vim.bo.buftype == '' then
	vim.opt.number = true
else
	vim.opt.number = false
end
vim.api.nvim_command('let g:coq_settings = {"auto_start": "shut-up"}')

---- Keymappings ----
vim.g.mapleader = ','
vim.keymap.set({ 'n', 'i', 'c', 't' }, '<F13>', '<cmd>tabprevious<cr>')
vim.keymap.set({ 'n', 'i', 'c', 't' }, '<F14>', '<cmd>tabnext<cr>')

---- Set up lazy ----
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
		},
	},
	{ 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
	{ 'fladson/vim-kitty' },
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
		build = ':TSUpdate',
		config = function()
			local configs = require('nvim-treesitter.configs')
			configs.setup({
				ensure_installed = {
					'c',
					'lua',
					'vim',
					'vimdoc',
					'query',
					'elixir',
					'heex',
					'javascript',
					'html',
					'java',
					'markdown_inline',
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = false },
			})
		end,
	},
	{
		'numToStr/Comment.nvim',
		opts = {
			-- config here
		},
		lazy = false,
	},
	{
		'iamcco/markdown-preview.nvim',
		ft = { 'markdown' },
		build = function()
			vim.fn['mkdp#util#install']()
		end,
	},
	{ 'sfztools/sfz.vim' },
	{ 'sitiom/nvim-numbertoggle' },
	{
		'ms-jpq/coq_nvim',
		branch = 'coq',
		dependencies = {
			{ 'ms-jpq/coq.artifacts', branch = 'artifacts' },
			{ 'ms-jpq/coq.thirdparty', branch = '3p' },
		},
	},
	{
		'williamboman/mason.nvim',
		dependencies = {
			{ 'williamboman/mason-lspconfig.nvim' },
			{ 'neovim/nvim-lspconfig' },
		},
	},
	{
		'bluz71/vim-nightfly-colors',
		name = 'nightfly',
		lazy = false,
		priority = 1000,
	},
	{ 'mfussenegger/nvim-lint' },
	{ url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git' },
	{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },
	{ 'mhartington/formatter.nvim' },
})

vim.keymap.set({ 'n', 'i', 'c', 't' }, '<F15>', '<cmd>Neotree float<cr>')

require('ts_context_commentstring').setup {}
require('Comment').setup({
	pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

---- Colorscheme ----
vim.cmd [[colorscheme nightfly]]

---- Indentation highlighting ----
local highlight = {
	'RainbowRed',
	'RainbowYellow',
	'RainbowBlue',
	'RainbowOrange',
	'RainbowGreen',
	'RainbowViolet',
	'RainbowCyan',
}
local hooks = require 'ibl.hooks'
-- create the highlight groups in the highlight setup hook, so they are reset every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
	vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
	vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
	vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
	vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
	vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
	vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
end)

require('ibl').setup {
	indent = { highlight = highlight },
	scope = { enabled = false },
}

---- Rainbow Delimiters ----
local rainbow_delimiters = require 'rainbow-delimiters'

vim.g.rainbow_delimiters = {
	strategy = {
		[''] = rainbow_delimiters.strategy['global'],
		vim = rainbow_delimiters.strategy['local'],
	},
	query = { [''] = 'rainbow-delimiters', lua = 'rainbow-blocks' },
	highlight = {
		'RainbowDelimiterRed',
		'RainbowDelimiterYellow',
		'RainbowDelimiterBlue',
		'RainbowDelimiterOrange',
		'RainbowDelimiterGreen',
		'RainbowDelimiterViolet',
		'RainbowDelimiterCyan',
	},
}

---- Language configuration ----
-- Language tools
local lspconfig = require('lspconfig')
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup {
	-- a list of all tools you want to ensure are installed upon start; they should be the names Mason uses for each tool
	ensure_installed = {
		'clangd',
		'cpplint',
		'cpptools',
		'ltex-ls',
		'lua-language-server',
		'luacheck',
		'luaformatter',
	},
}

-- Linting
require('lint').linters_by_ft = { cpp = { 'cpplint' } }
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
	callback = function()
		require('lint').try_lint()
	end,
})

-- Formatting
-- Utilities for creating configurations
local util = require 'formatter.util'

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require('formatter').setup {
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here and will be executed in order
		lua = {
			function()
				return {
					exe = 'lua-format',
					args = {
						util.escape_path(util.get_current_buffer_file_path()),
						'--indent-width=1',
						'--use-tab',
						'--no-keep-simple-control-block-one-line',
						'--no-keep-simple-function-one-line',
						'--chop-down-table',
						'--extra-sep-at-table-end',
						'--spaces-inside-table-braces',
						'--double-quote-to-single-quote',
					},
					stdin = true,
				}
			end,
		},

		-- Use the special "*" filetype for defining formatter configurations on any filetype
		['*'] = {
			-- "formatter.filetypes.any" defines default configurations for any filetype
			require('formatter.filetypes.any').remove_trailing_whitespace,
		},
	},
}

-- Python
lspconfig.pyright.setup {}
vim.api.nvim_create_autocmd({ 'Filetype' }, {
	pattern = { 'python' },
	callback = function(ev)
		vim.api.nvim_command('setlocal autoindent noexpandtab tabstop=4 shiftwidth=4')
	end,
})

-- Markup
lspconfig.ltex.setup {}
vim.api.nvim_command('let g:markdown_fenced_languages = ["dart", "python", "ruby", "go"]')

-- C/C++
lspconfig.clangd.setup {}

-- Lua
lspconfig.lua_ls.setup {}

-- Java
lspconfig.jdtls.setup {}
