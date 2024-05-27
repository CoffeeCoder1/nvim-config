return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
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
				'markdown',
				'markdown_inline',
				'rust',
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = false },
		},
		config = function(_, opts)
			local configs = require('nvim-treesitter.configs')
			configs.setup(opts)
		end,
	},
}