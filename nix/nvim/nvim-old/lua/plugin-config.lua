-- Syntax highlighting
-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`

require('nvim-treesitter.configs').setup {
	-- Add languages to be installed here that you want installed for treesitter

	-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
}

require('lsp-config')
require('autocompletion-setup')
