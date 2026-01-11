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
  use 'akinsho/flutter-tools.nvim'
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

  --git
  use 'lewis6991/gitsigns.nvim'
  use 'dinhhuy258/git.nvim'

  --floating terminal
  use 'voldikss/vim-floaterm'

	--searching
	use { 'nvim-telescope/telescope.nvim' }

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
	use 'nvim-lua/plenary.nvim' --ui components
  use 'MunifTanjim/nui.nvim' --ui components
  use 'rebelot/kanagawa.nvim' --best colorscheme I have found
	use 'lukas-reineke/indent-blankline.nvim' --indent hints
	use 'RRethy/vim-illuminate' --hl other under cusor
  use 'm-demare/hlargs.nvim' --hl args
	use 'junegunn/rainbow_parentheses.vim' --different colored paras (not working rn)
	use 'psliwka/vim-smoothie' -- smooth scrollpsliwka/vim-smoothie
  use 'norcalli/nvim-colorizer.lua' --color diplay for csslike
  use { 'akinsho/bufferline.nvim', tag = "*" } --bufferline

	-- Quality of life
	use { 'echasnovski/mini.pairs', version = false } -- autopairs
	use 'mluders/comfy-line-numbers.nvim' --left hand jumps only
	use 'tpope/vim-surround' --Surround text objects
	use 'tpope/vim-repeat' --patch for the above
  use 'tpope/vim-obsession' --Session management
	use 'rhysd/clever-f.vim' --makes f/F/t/T repeat by default
  use 'AndrewRadev/switch.vim' --toggle expressions using gs
  use 'gerazov/vim-toggle-bool' --toggle booleans using gs
  use 'windwp/nvim-ts-autotag' --html autotags

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
require("leetcode").setup({
  -- your opts go here
  lang = "c",
})

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
require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "rust_analyzer", "clangd", "ts_ls", "svelte"},
})
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

local lsp = require('lspconfig')
lsp.ruff.setup {}
lsp.ts_ls.setup {}
lsp.pyright.setup({})
lsp.dartls.setup{}
lsp.svlete.setup{}

require("flutter-tools").setup{
  flutter_path = vim.fn.getcwd() .. "/.fvm/flutter_sdk/bin/flutter",
  lsp = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
  dev_log = {
    enabled = true,
    notify_errors = true,
  },
  widget_guides = { enabled = true },
  closing_tags = { highlight = "ErrorMsg", prefix = "//" },
}

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
require('nvim-treesitter.config').setup {
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

-- force setup
require'hop'.setup {}
require('ibl').setup()
require('hlargs').setup()
require('mini.pairs').setup()
require('nvim-ts-autotag').setup()
require('colorizer').setup()
require('git').setup()

--setup marks
require('marks').setup {
  default_mappings = true,
  builtin_marks = {},
  cyclic = true,
  force_write_shada = false,
  refresh_interval = 150,
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  excluded_filetypes = {},
  excluded_buftypes = {},
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
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
