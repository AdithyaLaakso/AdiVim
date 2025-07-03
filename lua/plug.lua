-- Bootstrap
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
ensure_packer()

-- Plugin setup
require('packer').startup(function(use)

	--Plugins (duh)
  use 'wbthomason/packer.nvim'

  -- Zen mode
  use { 'folke/zen-mode.nvim' }

  -- Fuzzy Finder
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }
  use 'junegunn/fzf.vim'

  -- Rust LSP
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'simrat39/rust-tools.nvim'

  --auto-complete
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/vim-vsnip'

  --parsing
  use 'nvim-treesitter/nvim-treesitter'

  --debug
  use 'puremourning/vimspector'

  --floating terminal
  use 'voldikss/vim-floaterm'

	--searching
	use 'nvim-lua/plenary.nvim'
	use {'nvim-telescope/telescope.nvim', tag = '0.1.8'}
	use {
		'smoka7/hop.nvim',
		branch = 'v2',
		config = function ()
			require'hop'.setup {}
		end
	}

	--project management
	use 'nvim-tree/nvim-tree.lua'
	use 'nvim-tree/nvim-web-devicons'
	use 'preservim/tagbar'
  use "folke/trouble.nvim"

  -- asthetics
  use 'rebelot/kanagawa.nvim'
	use 'lukas-reineke/indent-blankline.nvim' --indent hints
	use 'windwp/nvim-autopairs' --autopairs
	use 'RRethy/vim-illuminate' --hl other under cusor
  use 'm-demare/hlargs.nvim' --hl args
	use 'MunifTanjim/nui.nvim' --ui components
	use 'junegunn/rainbow_parentheses.vim' -- different colored paras
	use 'psliwka/vim-smoothie' -- smooth scrollpsliwka/vim-smoothie

	--Tools
	use 'tpope/vim-surround' --Change Surround e.g. (hello) becomes <q>hello</q> after cs(<q>

	--Leetcode
	use {
		"kawre/leetcode.nvim",
		requires = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		run = ":TSUpdate html", -- only needed if using nvim-treesitter
		config = function()
			require("leetcode").setup({
				-- your opts go here
				lang = "c",
			})
		end,
  }

	--golf
	use 'vuciv/golf'

end)

-- Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup()
local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

-- LSP Diagnostics Options Setup
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
    set signcolumn=yes
    autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<Tab>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- Treesitter Plugin Setup
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- Treesitter folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- Vimspector options
vim.cmd([[
	let g:vimspector_sidebar_width = 85
	let g:vimspector_bottombar_height = 15
	let g:vimspector_terminal_maxwidth = 70
]])

-- Vimspector
--vim.cmd([
--nmap <F9> <cmd>call vimspector#Launch()<cr>
--nmap <F5> <cmd>call vimspector#StepOver()<cr>
--nmap <F8> <cmd>call vimspector#Reset()<cr>
--nmap <F11> <cmd>call vimspector#StepOver()<cr>
--nmap <F12> <cmd>call vimspector#StepOut()<cr>
--nmap <F10> <cmd>call vimspector#StepInto()<cr>
--])

--nvim-tree Options
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open

local add_to_trouble = require("trouble.sources.telescope").add

local telescope = require("telescope")

telescope.setup({
  defaults = {
    mappings = {
      i = { ["<c-t>"] = open_with_trouble },
      n = { ["<c-t>"] = open_with_trouble },
			},
  },
})

-- force hop setup
require'hop'.setup {}

--get nice indent hints
require('ibl').setup()

--setup hlargs
require('hlargs').setup()

-- Theme
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("colorscheme kanagawa")
  end,
})
