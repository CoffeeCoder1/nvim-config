---- VIM Setup ----
-- vim.api.nvim_command('filetype plugin indent off')

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
vim.keymap.set({ 'n', 'i', 'c', 't' }, '<F2>', '<cmd>tabprevious<cr>')
vim.keymap.set({ 'n', 'i', 'c', 't' }, '<F4>', '<cmd>tabnext<cr>')

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
						'rust',
					},
					sync_install = false,
					highlight = { enable = true },
					indent = { enable = false },
				})
			end,
		},
		{
			'iamcco/markdown-preview.nvim',
			ft = { 'markdown' },
			build = function()
				vim.fn['mkdp#util#install']()
			end,
		},
		{ 'sfztools/sfz.vim' },
		{ 'mfussenegger/nvim-jdtls' },
		{ 'sitiom/nvim-numbertoggle' },
		{
			'ms-jpq/coq_nvim',
			branch = 'coq',
			dependencies = {
				{ 'ms-jpq/coq.artifacts',  branch = 'artifacts' },
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
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					-- Customize or remove this keymap to your liking
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_fallback = true })
					end,
					mode = "",
					desc = "Format buffer",
				},
			},
			-- Everything in opts will be passed to setup()
			opts = {
				-- Define your formatters
				formatters_by_ft = {
					--lua = { "stylua" },
					--python = { "isort", "black" },
					--javascript = { { "prettierd", "prettier" } },
				},
				-- Set up format-on-save
				--format_on_save = { timeout_ms = 500, lsp_fallback = true },
				-- Customize formatters
				formatters = {
					shfmt = {
						prepend_args = { "-i", "2" },
					},
				},
			},
			init = function()
				-- If you want the formatexpr, here is the place to set it
				vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			end,
		},
		{
			'mrcjkb/rustaceanvim',
			version = '^4', -- Recommended
			ft = { 'rust' },
		},
	},
	{
		dev = {
			path = "~/git-repos/nvim-plugins/"
		}
	}

)

vim.keymap.set({ 'n', 'i', 'c', 't' }, '<F3>', '<cmd>Neotree float reveal<cr>')

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
		'jdtls',
		'rust-analyzer',
		'json-lsp',
		'arduino-language-server',
	},
}

-- Linting
require('lint').linters_by_ft = { cpp = { 'cpplint' } }
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
	callback = function()
		require('lint').try_lint()
	end,
})

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

-- JSON
lspconfig.jsonls.setup {}

-- Arduino
lspconfig.arduino_language_server.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	end,
})
