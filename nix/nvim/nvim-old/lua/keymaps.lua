-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>cs', ':noh<CR>', { silent = true, desc = "[C]lear [S]earch" })


-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Telescope
-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Trouble
-- vim.keymap.set('n', '<leader>st', require('trouble.providers.telescope').open_with_trouble,	{ desc = '[S]earch [T]rouble' })
vim.keymap.set('n', '<leader>tt', require('trouble').toggle, { desc = '[T]rouble [T]oggle' })
vim.keymap.set('n', '<leader>tr', require('trouble').refresh, { desc = '[T]rouble [R]efresh' })
vim.keymap.set('n', '<leader>tw', function() require('trouble').toggle("workspace_diagnostics") end,
	{ desc = '[T]rouble [W]orkspache diagnostic' })
vim.keymap.set('n', '<leader>td', function() require('trouble').toggle("document_diagnostics") end,
	{ desc = '[T]rouble [D]ocument diagnostic' })
vim.keymap.set('n', '<leader>tq', function() require('trouble').toggle("quickfix") end, { desc = '[T]rouble [Q]uickfix' })
vim.keymap.set('n', '<leader>tL', function() require('trouble').toggle("loclist") end, { desc = '[T]rouble [L]ocallist' })
vim.keymap.set('n', '<leader>tl', function() require('trouble').toggle("lsp_references") end,
	{ desc = '[T]rouble [L]sp references' })
vim.keymap.set('n', '<leader>tn', function() require('trouble').next({ skip_groups = true, jump = true }) end,
	{ desc = '[T]rouble, [N]ext' })
vim.keymap.set('n', '<leader>tp', function() require('trouble').previous({ skip_groups = true, jump = true }) end,
	{ desc = '[T]rouble, [P]revious' })

-- Todo Comments
vim.keymap.set("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set('n', '<leader>tc', ':TodoTrouble<CR>', { desc = '[T]rouble [C]omments' })
vim.keymap.set('n', '<leader>sc', ':TodoTelescope<CR>', { desc = '[T]rouble [C]omments' })


-- Treesitter
-- See: plugin-config.lua

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Windows & buffers
-- Deleting buffer without closing split
vim.keymap.set('n', '<c-w>d', ':bp|bd #<CR>',
	{ desc = "Delete buffer without closing split", silent = true, noremap = true })

-- Executor
vim.keymap.set('n', '<leader>rr', ':ExecutorRun<CR>', { desc = '[R]un executor' })
vim.keymap.set('n', '<leader>rd', ':ExecutorToggleDetail<CR>', { desc = '[R]un [D]etails' })
vim.keymap.set('n', '<leader>rs', ':ExecutorSetCommand<CR>', { desc = '[R]un [S]et command' })
