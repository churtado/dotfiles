-- vim settings
vim.opt.backup = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 2
vim.opt.cursorline = true -- highlight the current line
vim.opt.expandtab = false -- convert tabs to spaces
vim.opt.mouse = "a"
vim.opt.number = true -- set numbered lines
vim.opt.numberwidth = 4 -- set number column with to 2 {default 4}
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2 -- number of spaces inserted for each indentation
vim.opt.signcolumn = "yes" -- always show the sign column
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.termguicolors = true
vim.opt.wrap = true



-- lunarvim settings
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.lualine.style = "default"
lvim.builtin.notify.active = true
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.terminal.active = true
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.rainbow.enable = true
lvim.colorscheme = "gruvbox-material"
lvim.format_on_save = true
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.leader = "space"
lvim.log.level = "warn"
lvim.use_icons = true
-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile



-- additional key mappings
local map = vim.api.nvim_set_keymap
local options = { noremap = true }
-- flip through buffers
map('n', ',m', ':bnext<cr>', options)
map('n', ',n', ':bprev<cr>', options)
-- git history of current file
map('n', ',gl', ':0Gclog<cr>', options)
-- grep search all files
map('n', ',g', ':Rg<cr>', options)
map('n', ',b', ':Buffers<cr>', options)
map('n', ',t', ':Marks<cr>', options)



-- trouble mappings
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
	{ silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
	{ silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
	{ silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
	{ silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
	{ silent = true, noremap = true }
)
-- vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
--   { silent = true, noremap = true }
-- )



-- diagnostic mappings
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>o', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist, opts)



-- code folding
local vim = vim
local opt = vim.opt
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

require('pretty-fold').setup {
	sections = {
		left = {
			'content',
		},
		right = {
			' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
			function(config) return config.fill_char:rep(3) end
		}
	},
	fill_char = '•',

	remove_fold_markers = false,

	-- Keep the indentation of the content of the fold string.
	keep_indentation = true,

	-- Possible values:
	-- "delete" : Delete all comment signs from the fold string.
	-- "spaces" : Replace all comment signs with equal number of spaces.
	-- false    : Do nothing with comment signs.
	process_comment_signs = 'spaces',

	-- Comment signs additional to the value of `&commentstring` option.
	comment_signs = {},

	-- List of patterns that will be removed from content foldtext section.
	stop_words = {
		'@brief%s*', -- (for C++) Remove '@brief' and all spaces after.
	},

	add_close_pattern = true, -- true, 'last_line' or false

	matchup_patterns = {
		{ '{', '}' },
		{ '%(', ')' }, -- % to escape lua pattern char
		{ '%[', ']' }, -- % to escape lua pattern char
	},

	ft_ignore = { 'neorg' },
}

-- fold preview mappings
local keymap = vim.keymap
keymap.amend = require('keymap-amend')
local map = require('fold-preview').mapping

keymap.amend('n', 'h', map.show_close_preview_open_fold)
keymap.amend('n', 'l', map.close_preview_open_fold)
keymap.amend('n', 'zo', map.close_preview)
keymap.amend('n', 'zO', map.close_preview)
keymap.amend('n', 'zc', map.close_preview_without_defer)
keymap.amend('n', 'zR', map.close_preview)
keymap.amend('n', 'zM', map.close_preview_without_defer)

require('fold-preview').setup {
	defaults = true
}



-- scrollbar setup
require("scrollbar").setup()



-- lsp setup
-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}
-- ruby lsp
-- require 'lspconfig'.solargraph.setup {}
require('lspconfig')['solargraph'].setup {
	cmd = { "/Users/mrenp/.local/share/nvim/lsp_servers/solargraph/bin/solargraph", "stdio" },
	on_attach = on_attach,
	flags = lsp_flags,
}
require('lspconfig')['pyright'].setup {
	on_attach = on_attach,
	flags = lsp_flags,
}
require('lspconfig')['rust_analyzer'].setup {
	on_attach = on_attach,
	flags = lsp_flags,
	-- Server-specific settings...
	settings = {
		["rust-analyzer"] = {}
	}
}

-- lsp packer setup
local use = require('packer').use

require('packer').startup(function()
	use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
	use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
end)

-- add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright' }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		-- on_attach = my_custom_on_attach,
		capabilities = capabilities,
	}
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}



-- vim setup, mostly grep search
vim.cmd([[
"###################### mundo settings #####################
" Enable persistent undo so that undo history persists across vim sessions
"set undofile
"set undodir=~/.vim/undo
"nnoremap <F5> :MundoToggle<CR>
"###################### fzf settings #####################
" This is the default extra key bindings
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-x': 'split',
\ 'ctrl-v': 'vsplit' }
" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
let $FZF_DEFAULT_COMMAND="rg --files --hidden"
let $FZF_DEFAULT_OPTS="--bind \"ctrl-n:preview-down,ctrl-p:preview-up\" --layout=reverse --info=inline --preview-window down:wrap"
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
\ 'bg':      ['bg', 'Normal'],
\ 'hl':      ['fg', 'Comment'],
\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment'] }
"Get Files
command! -bang -nargs=? -complete=dir Files
\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
" Get text in files with Rg
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
\   fzf#vim#with_preview(), <bang>0)
" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
let initial_command = printf(command_fmt, shellescape(a:query))
let reload_command = printf(command_fmt, '{q}')
let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" Git grep
command! -bang -nargs=* GGrep
\ call fzf#vim#grep(
\   'git grep --line-number '.shellescape(<q-args>), 0,
\   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
]])






-- parsers
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"tsx",
	"css",
	"rust",
	"java",
	"yaml",
}



-- formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
	--   { command = "black", filetypes = { "python" } },
	--   { command = "isort", filetypes = { "python" } },
	-- {
	--   command = "prettier",
	--   extra_args = { "--use-tabs=true", "--single-quote=true", "--jsx-single-quote=true" },
	--   filetypes = { "typescript", "typescriptreact" },
	-- },
	{
		command = "eslint_d",
		extra_args = { "-f", "json", "--stdin", "--fix-to-stdout", "--stdin-filename", "$FILENAME" },
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},
}



-- linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
	--   { command = "flake8", filetypes = { "python" } },
	-- {
	--   command = "prettier",
	--   extra_args = { "--use-tabs=true", "--single-quote=true", "--jsx-single-quote=true" },
	--   filetypes = { "typescript", "typescriptreact" },
	-- },
	{
		command = "eslint_d",
		---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
		filetypes = { "typescript", "typescriptreact" },
	},
}



-- Additional Plugins
lvim.plugins = {
	{
		"ahmedkhalf/lsp-rooter.nvim",
		event = "BufRead",
		config = function()
			require("lsp-rooter").setup()
		end,
	},
	-- TODO: fix this
	{ 'anuvyklack/pretty-fold.nvim' },
	{ 'anuvyklack/fold-preview.nvim' },
	{ 'anuvyklack/keymap-amend.nvim' },

	{ "camspiers/animate.vim" },
	{ "camspiers/lens.vim" },
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit", "gitrebase", "svn", "hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},
	{
		"folke/lsp-colors.nvim",
		event = "BufRead",
	},
	{ "folke/tokyonight.nvim" },
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"folke/todo-comments.nvim",
		-- event = "BufRead",
		config = function()
			require("todo-comments").setup {
				signs = true,
				keywords = {
					FIX = {
						icon = " ",
						color = "#D64A4A",
						alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
						-- signs = false, -- configure signs for some keywords individually
					},
					TODO = { icon = " ", color = "#458588" },
					HACK = { icon = " ", color = "#FABD2F" },
					WARN = { icon = " ", color = "#FABD2F", alt = { "WARNING", "XXX" } },
					PERF = { icon = " ", color = "#B16286", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "#8EC07C", alt = { "INFO" } },
					TEST = { icon = "⏲ ", alt = { "TESTING", "PASSED", "FAILED" } }
				}
			}
		end,
	},
	{
		"ggandor/lightspeed.nvim",
		event = "BufRead",
	},
	{ "junegunn/fzf" },
	{ "junegunn/fzf.vim" },
	{ "junegunn/vim-peekaboo" },
	{
		"kevinhwang91/nvim-bqf",
		event = { "BufRead", "BufNew" },
		config = function()
			require("bqf").setup({
				auto_enable = true,
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
				},
				func_map = {
					vsplit = "",
					ptogglemode = "z,",
					stoggleup = "",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
		end,
	},
	{ "kevinhwang91/nvim-ufo" },
	{
		"karb94/neoscroll.nvim",
		event = "WinScrolled",
		config = function()
			require('neoscroll').setup({
				-- All these keys will be mapped to their corresponding default scrolling animation
				mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
					'<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
				hide_cursor = true, -- Hide cursor while scrolling
				stop_eof = true, -- Stop at <EOF> when scrolling downwards
				use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
				respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
				cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
				easing_function = nil, -- Default easing function
				pre_hook = nil, -- Function to run before the scrolling animation starts
				post_hook = nil, -- Function to run after the scrolling animation ends
			})
		end
	},
	{
		"metakirby5/codi.vim",
		cmd = "Codi",
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	{
		"nvim-treesitter/playground",
		event = "BufRead",
	},
	{ "oberblastmeister/neuron.nvim" },
	{
		"Pocco81/auto-save.nvim",
		config = function()
			require("auto-save").setup()
		end,
	},
	{
		"p00f/nvim-ts-rainbow",
	},
	{ "peitalin/vim-jsx-typescript" },
	{ "petertriho/nvim-scrollbar" },
	{ "RishabhRD/popfix" },
	{ "RishabhRD/nvim-cheat.sh" },
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function() require "lsp_signature".on_attach() end,
	},
	{
		"romgrk/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup {
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				throttle = true, -- Throttles plugin updates (may improve performance)
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
					-- For all filetypes
					-- Note that setting an entry here replaces all other patterns for this entry.
					-- By setting the 'default' entry below, you can control which nodes you want to
					-- appear in the context window.
					default = {
						'class',
						'function',
						'method',
					},
				},
			}
		end
	},
	{ "sainnhe/gruvbox-material" },
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require('symbols-outline').setup()
		end
	},
	{
		"sindrets/diffview.nvim",
		event = "BufRead",
	},
	{ "slim-template/vim-slim" },
	{ "styled-components/vim-styled-components" },
	{
		"tzachar/cmp-tabnine",
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
		event = "InsertEnter",
	},
	{ "sudormrfbin/cheatsheet.nvim" },
	{ "tpope/vim-abolish" },
	{
		"tpope/vim-fugitive",
		cmd = {
			"G",
			"Git",
			"Gdiffsplit",
			"Gread",
			"Gwrite",
			"Ggrep",
			"GMove",
			"GDelete",
			"GBrowse",
			"GRemove",
			"GRename",
			"Glgrep",
			"Gedit"
		},
		ft = { "fugitive" }
	},
	-- { "tpope/vim-rails" },
	{ "tpope/vim-repeat" },
	{ "tpope/vim-sleuth" },
	{ "tpope/vim-surround" },
	{
		"turbio/bracey.vim",
		cmd = { "Bracey", "BracyStop", "BraceyReload", "BraceyEval" },
		run = "npm install --prefix server",
	},
	{
		"windwp/nvim-spectre",
		event = "BufRead",
		config = function()
			require("spectre").setup()
		end,
	},
	-- {
	-- 	'wfxr/minimap.vim',
	-- 	run = "cargo install --locked code-minimap",
	-- 	-- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
	-- 	config = function()
	-- 		vim.cmd("let g:minimap_width = 10")
	-- 		vim.cmd("let g:minimap_auto_start = 1")
	-- 		vim.cmd("let g:minimap_auto_start_win_enter = 1")
	-- 	end,
	-- },
}
