return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'mason.nvim',
			'mason-lspconfig.nvim',
		},
		opts = function()
			return {
				-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
				inlay_hints = {
					enabled = true,
				},
				-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
				codelens = {
					enabled = false,
				},
			}
		end,
		config = function(_, opts)
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
					local keymap_opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, keymap_opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, keymap_opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, keymap_opts)
					vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, keymap_opts)
					vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, keymap_opts)
					vim.keymap.set('n', '<space>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, keymap_opts)
					vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, keymap_opts)
					vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, keymap_opts)
					vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, keymap_opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, keymap_opts)

					if vim.fn.has('nvim-0.10') == 1 then
						-- inlay hints
						if opts.inlay_hints.enabled then
							vim.lsp.inlay_hint.enable()
						end

						-- code lens
						-- if opts.codelens.enabled and vim.lsp.codelens then
						-- 	lsp_util.on_supports_method("textDocument/codeLens",
						-- 		function(client, buffer)
						-- 			vim.lsp.codelens.refresh()
						-- 			vim.api.nvim_create_autocmd(
						-- 				{ "BufEnter", "CursorHold", "InsertLeave" },
						-- 				{
						-- 					buffer = buffer,
						-- 					callback = vim.lsp.codelens
						-- 					    .refresh,
						-- 				})
						-- 		end)
						-- end
					end
				end,
			})

			-- Set up the language servers installed through Mason
			require('mason-lspconfig').setup_handlers({
				-- The first entry (without a key) will be the default handler and will be called for each installed server that doesn't have a dedicated handler.
				function(server_name) -- default handler (optional)
					require('lspconfig')[server_name].setup {}
				end,
				-- Disable servers that are set up with a dedicated plugin (they are not initialized here to allow them to be lazy-loaded)
				['rust_analyzer'] = function()
				end,
				['jdtls'] = function()
				end,
			})
		end,
	},
	{
		'williamboman/mason.nvim',
		lazy = false,
		opts = {},
	},
	{ 'williamboman/mason-lspconfig.nvim' },
	{
		'WhoIsSethDaniel/mason-tool-installer.nvim',
		lazy = false,
		dependencies = {
			{ 'mason.nvim' },
		},
		opts = {
			-- a list of all tools you want to ensure are installed upon start; they should be the names Mason uses for each tool
			ensure_installed = {
				'python-lsp-server',
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
				'groovy-language-server',
				'lemminx',
			},
		},
	},
}
