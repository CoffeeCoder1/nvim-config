return {
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
			'MunifTanjim/nui.nvim',
		},
		cmd = {
			'Neotree',
		},
		keys = {
			{
				-- Customize or remove this keymap to your liking
				'<F3>',
				function()
					vim.api.nvim_command('Neotree float reveal')
				end,
				mode = { 'n', 'i', 'c', 't' },
				desc = 'Open Neotree',
			},
		},
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					show_hidden_count = true,
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = {
						-- '.git',
						'.DS_Store',
						'thumbs.db',
					},
					never_show = {},
				},
			},
		},
	},
}