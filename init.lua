---- VIM Setup ----
-- vim.api.nvim_command('filetype plugin indent off')

---- Editor settings ----
vim.opt.termguicolors = true
if vim.bo.buftype == '' then
	vim.opt.number = true
else
	vim.opt.number = false
end

-- Line wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true

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

require('lazy').setup(
	{
		{ import = 'plugins' },
	},
	{
		dev = {
			path = '~/git-repos/nvim-plugins/',
		},
		change_detection = {
			notify = false, -- get a notification when configuration changes are found
		},
	}
)