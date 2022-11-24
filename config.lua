-- general
lvim.log.level = "warn"
lvim.builtin.lualine.style = "default"
-- lvim.format_on_save = true
lvim.colorscheme = "gruvbox-material"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false



-- folding
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



-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
local map = vim.api.nvim_set_keymap
local options = { noremap = true }
-- basic mappings
-- flip through buffers
map('n', ',m', ':bnext<cr>', options)
map('n', ',n', ':bprev<cr>', options)
-- git history of current file
map('n', ',gl', ':0Gclog<cr>', options)
-- grep search all files
map('n', ',g', ':Rg<cr>', options)
map('n', ',b', ':Buffers<cr>', options)
map('n', ',t', ':Marks<cr>', options)



-- scrollbar setup
require("scrollbar").setup()



-- TODO list setup
require("todo-comments").setup {
  signs = false,
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
    TEST = { icon = "⏲ ", alt = { "TESTING", "PASSED", "FAILED" } },
  }
}



-- lsp setup
require 'lspconfig'.solargraph.setup {}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>o', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>d', vim.diagnostic.setloclist, opts)

-- Trouble mappings
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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
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

-- Add additional capabilities supported by nvim-cmp
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



lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics" },
-- }



-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false



-- if you don't want all the parsers change this to a table of the ones you want
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



lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true



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
  { 'anuvyklack/pretty-fold.nvim' },
  { 'anuvyklack/fold-preview.nvim' },
  { 'anuvyklack/keymap-amend.nvim' },
  { "camspiers/animate.vim" },
  { "camspiers/lens.vim" },
  { "folke/tokyonight.nvim" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "folke/todo-comments.nvim" },
  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },
  { "junegunn/vim-peekaboo" },
  { "kevinhwang91/nvim-ufo" },
  { "pechorin/any-jump.vim" },
  { "peitalin/vim-jsx-typescript" },
  { "petertriho/nvim-scrollbar" },
  { "RishabhRD/popfix" },
  { "RishabhRD/nvim-cheat.sh" },
  { "sainnhe/gruvbox-material" },
  { "slim-template/vim-slim" },
  { "styled-components/vim-styled-components" },
  { "sudormrfbin/cheatsheet.nvim" },
  { "tpope/vim-abolish" },
  { "tpope/vim-fugitive" },
  -- { "tpope/vim-rails" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-surround" }
}
