-- Get path to JDTLS from Mason
local jdtls_bin = require('mason-registry').get_package('jdtls'):get_install_path() .. '/jdtls'

-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand('~/java-workspace/') .. project_name
local root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1])

-- Find formatter configuration file
local formatter_config = vim.fs.find('eclipse-formatter.xml', { type = 'file' })[1]

local config = {
	cmd = {
		jdtls_bin,
		'--data', workspace_dir
	},
	settings = {
		['java.format.settings.url'] = formatter_config
	},
	root_dir = root_dir,
}
require('jdtls').start_or_attach(config)
