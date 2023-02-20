call plug#begin()
Plug 'rmagatti/goto-preview'
Plug 'neovim/nvim-lspconfig'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'jiangmiao/auto-pairs'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For vsnip users.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" For luasnip users.
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" For ultisnips users.
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" For snippy users.
Plug 'dcampos/nvim-snippy'
Plug 'dcampos/cmp-snippy'
call plug#end()

luafile ~/.vim/lsp_config.lua

lua <<EOF
-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
	-- REQUIRED - you must specify a snippet engine
	expand = function(args)
	vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
	-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
	-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
	end,
},
window = {
	-- completion = cmp.config.window.bordered(),
	-- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
['<C-b>'] = cmp.mapping.scroll_docs(-4),
['<C-f>'] = cmp.mapping.scroll_docs(4),
['<C-Space>'] = cmp.mapping.complete(),
['<C-e>'] = cmp.mapping.abort(),
['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
{ name = 'nvim_lsp' },
{ name = 'vsnip' }, -- For vsnip users.
-- { name = 'luasnip' }, -- For luasnip users.
-- { name = 'ultisnips' }, -- For ultisnips users.
-- { name = 'snippy' }, -- For snippy users.
}, {
	{ name = 'buffer' },
})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
	{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
	})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
	})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
	{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
	})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
	capabilities = capabilities
}

require('goto-preview').setup {
	width = 120; -- Width of the floating window
	height = 15; -- Height of the floating window
	border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
	default_mappings = false; -- Bind default mappings
	debug = false; -- Print debug information
	opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
	resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
	post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
	references = { -- Configure the telescope UI for slowing the references cycling window.
	telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
	};
	-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
	focus_on_open = true; -- Focus the floating window when opening it.
	dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
	force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
	bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}
EOF

  colorscheme tokyonight
  set number
  nnoremap <C-n> :tabnew

  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>

  nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
  nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
  nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
  nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
  nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
