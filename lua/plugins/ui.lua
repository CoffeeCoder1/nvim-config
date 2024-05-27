return {
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		lazy = false,
		opts = {
			indent = {
				highlight = {
					'RainbowRed',
					'RainbowYellow',
					'RainbowBlue',
					'RainbowOrange',
					'RainbowGreen',
					'RainbowViolet',
					'RainbowCyan',
				},
			},
			scope = {
				enabled = false,
			},
		},
		config = function(plugin, opts)
			local hooks = require'ibl.hooks'
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

			require(plugin.main).setup(opts)
		end,
	},
	{ 'sitiom/nvim-numbertoggle' },
	{
		url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git',
		main = 'rainbow-delimiters.setup',
		opts = function()
			local rainbow_delimiters = require('rainbow-delimiters')
			return {
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
		end,
	},
}