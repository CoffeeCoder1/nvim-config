return {
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
}