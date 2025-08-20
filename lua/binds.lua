local keymap = vim.api.nvim_set_keymap
-------------------------------------------------------------------------------
--	WINDOWS -------------------------------------------------------------------
-------------------------------------------------------------------------------
keymap( "n",
	"HH",
	"<C-w>h",
	{ desc = "Move to window left" }
)
keymap( "n",
	"Hh",
	'<Cmd>vertical resize -7" <CR>"',
	{ desc = "Shrink window (left)" }
)
keymap( "n",
	"Hn",
	"<C-w>v<C-w>H",
	{ desc = "New window left" }
)
keymap( "n",
	"LL",
	"<C-w>l",
	{ desc = "Move to window right" }
)
keymap( "n",
	"Ll",
	"<Cmd>vertical resize +7 <CR>",
	{ desc = "Grow window (right)" }
)
keymap( "n",
	"Ln",
	"<C-w>v",
	{ desc = "New window right" }
)
keymap( "n",
	"<C-q>",
	"<Cmd>bdelete<CR><Cmd>close<CR>",
	{ desc = "Close window and buffer" }
)
keymap( "n",
	"<Tab>",
	"<C-w>w",
	{ desc = "Next window" }
)
keymap( "n",
	"<S- Tab>",
	"<C-w> W",
	{ desc = "Previous window" }
)

-------------------------------------------------------------------------------
--	MINI-MACRO ----------------------------------------------------------------
-------------------------------------------------------------------------------
keymap("n",
	"KJ",
	"i<CR><Esc>k$",
	{ desc = "Split line at cursor down" }
)
keymap(
	'n',
	'KK',
	"i<CR><Esc>k$<Cmd>m +1<CR>",
	{ desc = "Split line at cursor up" }
)
keymap(
	'n',
	'KH',
	"\"_ddO<Esc>",
	{ desc = "replace with newline no register" }
)
keymap(
	'n',
	'KS',
	"gcc",
	{ desc = "More ergo comment" }
)
vim.keymap.set("n", "Kv", function()
  local ve = vim.opt.virtualedit:get()
  if ve[1] == "all" then
    vim.opt.virtualedit = "none"
  else
    vim.opt.virtualedit = "all"
  end
end, { desc = "Toggle virtualedit all/none" })
vim.keymap.set("n", "Kvb", function()
  local ve = vim.opt.virtualedit:get()
  if ve[1] == "block" then
    vim.opt.virtualedit = "none"
  else
    vim.opt.virtualedit = "block"
  end
end, { desc = "Toggle virtualedit block/none" })

keymap( 'n',
	'KX',
	[[:s/\s\+$//<CR>]],
	{ desc = "Trim trailing whitespace" }
)
keymap( 'n',
	'KY',
	"mxgg\"+yG'x",
	{ desc = "Yank entire buffer to system clipboard without moving" }
)
keymap( "n",
	"K;",
	"mzA;<Esc>`z",
	{ desc = "Add ; to end of line" }
)
keymap( "n",
	"K,",
	"mzA,<Esc>`z",
	{ desc = "Add , to end of line" }
)

-- swap bindings for ; and : based on use
vim.keymap.set({"n", "v"},
	":",
	";",
	{ noremap= true, desc = "swap colon types based on use" }
)
vim.keymap.set({"n", "v"},
	";",
	":",
	{ noremap= true, desc = "swap colon types based on use" }
)

-- s/S/^s is a anti pattern and so is ^
vim.keymap.set({"n", "v"},
	"s",
	"^",
	{ noremap= true, desc= "little s to jump to line start" }
)
vim.keymap.set({"n", "v"},
	"S",
	"$",
	{ noremap= true, desc= "big S to jump to line end" }
)
vim.keymap.set("n",
	"<C-s>",
	"<C-^>",
	{ noremap= true, desc= "control s to \"switch\" buffers" }
)

-- control h to escape
vim.keymap.set({"i"}, "<C-h>", "<Esc>")

-------------------------------------------------------------------------------
--	LEADER --------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Keybindings
vim.g.mapleader = ' '
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

--Trouble
local trouble = require("trouble")

vim.keymap.set("n", "<leader>xx",
	function()
		trouble.toggle("diagnostics")
	end,
	{ desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX",
	function()
		trouble.toggle("diagnostics",
		{ filter = { buf = 0 } })
	end,
	{ desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xcs",
	function()
		trouble.toggle("symbols",
		{ focus = false })
	end,
	{ desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>xcl",
	function()
		trouble.toggle("lsp", { focus = false, win = { position = "right" } })
	end,
	{ desc = "LSP Definitions / References (Trouble)" })
vim.keymap.set("n", "<leader>xL",
	function()
		trouble.toggle("loclist")
	end,
	{ desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ",
	function()
		trouble.toggle("qflist")
	end,
	{ desc = "Quickfix List (Trouble)" })

-- move lines
keymap('n', '<C-j>', ':m .+1<CR>==', opts)
keymap('n', '<C-k>', ':m .-2<CR>==', opts)
keymap('i', '<C-j>', '<Esc>:m .+1<CR>==gi', opts)
keymap('i', '<C-k>', '<Esc>:m .-2<CR>==gi', opts)
keymap('v', '<C-j>', ":m '>+1<CR>gv=gv", opts)
keymap('v', '<C-k>', ":m '<-2<CR>gv=gv", opts)

-- remove highlight
keymap('n', '<leader>n', ":noh<CR>", opts)

-- write file
keymap("n", "<leader>w", ":w<CR>", opts)

-- reload luafile
keymap("n", "<leader>L", ":luafile ~/.config/nvim/init.lua<CR>", opts)

-- buffers
keymap('n', '<C-n>', ":bn<CR>", opts)
keymap('n', '<C-b>', ":bp<CR>", opts)

-- Zen mode
keymap('n', '<leader>z', ':ZenMode<CR>', opts)

-- fzf menu
keymap('n', '<leader>e', ':Files<CR>', opts)
keymap('n', '<leader>h', ':History<CR>', opts)
keymap('n', '<leader>b', ':Buffers<CR>', opts)

-- Floating terminal
keymap('n', "<leader>s", ":FloatermToggle myfloat<CR>", opts)
keymap('t', "<Esc>", "<C-\\><C-n>:q<CR>", opts)

keymap('n', "<leader>Db", ":call vimspector#ToggleBreakpoint()<cr>", opts)
keymap('n', "<leader>Dw", ":call vimspector#AddWatch()<cr>", opts)
keymap('n', "<leader>De", ":call vimspector#Evaluate()<cr>", opts)

-- Telescope
keymap('n', '<leader>ff', ':Telescope find_files<cr>', opts)
keymap('n', '<leader>fg', ':Telescope live_grep<cr>', opts)
keymap('n', '<leader>fb', ':Telescope buffers<cr>', opts)
keymap('n', '<leader>fh', ':Telescope help_tags<cr>', opts)

-- Hop
keymap('n', '<leader>hw', ':HopWord <cr>', opts)
keymap('n', '<leader>hc', ':HopChar1', opts)
keymap('n', '<leader>h2', ':HopChar2', opts)
keymap('n', '<leader>hl', ':HopLineStart <cr>', opts)
keymap('n', '<leader>hv', ':HopVertical <cr>', opts)
keymap('n', '<leader>hz', ':HopLine <cr>', opts)
keymap('n', '<leader>hp', ':HopPattern <cr>', opts)

-- Nvim-tree
keymap('n', '<leader>tt', ':NvimTreeToggle <cr>', opts)
keymap('n', '<leader>tf', ':NvimTreeFindFile <cr>', opts)
keymap('n', '<leader>tc', ':NvimTreeCollapse <cr>', opts)

-- tags
keymap('n', '<leader>tb', ':TagbarToggle <cr>', opts)
keymap('n', '<leader>tj', ':TagbarAutoClose <cr>', opts)
