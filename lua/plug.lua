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

  -- LSP
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'simrat39/rust-tools.nvim'	-- Language support: Rust
	use 'sheerun/vim-polyglot' -- language defaults to fall back on

  -- For exploring config files
  use 'Owen-Dechow/videre.nvim'

  --auto-complete
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/vim-vsnip'

  --marks
  use 'chentoast/marks.nvim'

  --parsing
  use 'nvim-treesitter/nvim-treesitter'

  --debug
  use 'puremourning/vimspector' -- have not figured out how to use yet

  --floating terminal
  use 'voldikss/vim-floaterm'

	--searching
	-- use {'nvim-telescope/telescope.nvim', tag = '0.1.8'}

	-- Navigation
	use {
		'smoka7/hop.nvim',
		config = function ()
			require'hop'.setup {}
		end
	}

	--project management
	use 'nvim-tree/nvim-tree.lua'
	use 'nvim-tree/nvim-web-devicons'
	use 'preservim/tagbar'
  use 'folke/trouble.nvim'
	use 'brianhuster/unnest.nvim' --flatted neovim sessions

  -- asthetics
	use 'nvim-lua/plenary.nvim'
  use 'rebelot/kanagawa.nvim' --best colorscheme I have found
	use 'lukas-reineke/indent-blankline.nvim' --indent hints
	use 'RRethy/vim-illuminate' --hl other under cusor
  use 'm-demare/hlargs.nvim' --hl args
	use 'MunifTanjim/nui.nvim' --ui components
	use 'junegunn/rainbow_parentheses.vim' -- different colored paras
	use 'psliwka/vim-smoothie' -- smooth scrollpsliwka/vim-smoothie

	-- Quality of life
	use 'echasnovski/mini.pairs' -- autopairs
	use 'mluders/comfy-line-numbers.nvim' --left hand jumps only
	use 'tpope/vim-surround' --Surround text objects
	use 'tpope/vim-repeat' --patch for the above
  use 'tpope/vim-obsession' --Session management
	use 'rhysd/clever-f.vim' --makes f/F/t/T repeat by default

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

--comfy jump setup
require('comfy-line-numbers').setup({
  labels = {
    '1', '2', '3', '4', '5', '11', '12', '13', '14', '15', '21', '22', '23',
    '24', '25', '31', '32', '33', '34', '35', '41', '42', '43', '44', '45',
    '51', '52', '53', '54', '55', '111', '112', '113', '114', '115', '121',
    '122', '123', '124', '125', '131', '132', '133', '134', '135', '141',
    '142', '143', '144', '145', '151', '152', '153', '154', '155', '211',
    '212', '213', '214', '215', '221', '222', '223', '224', '225', '231',
    '232', '233', '234', '235', '241', '242', '243', '244', '245', '251',
    '252', '253', '254', '255',
  },
  up_key = 'k',
  down_key = 'j',

  -- Line numbers will be completely hidden for the following file/buffer types
  hidden_file_types = { 'undotree' },
  hidden_buffer_types = { 'terminal' }
})

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
  ensure_installed = { "lua", "rust", "toml", "c", "python"},
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

-- Treesitter folding (I hate this but occasionally it is useful)
-- vim.wo.foldmethod = 'expr'
-- vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

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

--setup marks
require('marks').setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 150,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- disables mark tracking for specific buftypes. default {}
  excluded_buftypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
    -- defaults to false.
    annotate = false,
  },
  mappings = {}
}

-- Theme
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("colorscheme kanagawa")
  end,
})

-- vim-smoothie work for all mappings
vim.g.smoothie_experimental_mappings = true
