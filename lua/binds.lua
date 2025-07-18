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
	'<Cmd>vertical resize -2" <CR>"',
	{ desc = "Shrink window (left)" }
)
keymap( "n",
	"Hn",
	"<C-w>v< C-w>H",
	{ desc = "New window left" }
)
keymap( "n",
	"LL",
	"<C-w>l",
	{ desc = "Move to window right" }
)
keymap( "n",
	"Ll",
	"<Cmd>vertical resize +2 <CR>",
	{ desc = "Grow window (right)" }
)
keymap( "n",
	"Ln",
	"<C-w>v",
	{ desc = "New window right" }
)
keymap( "n",
	"QQ",
	"<Cmd>close<CR>",
	{ desc = "Close window" }
)
keymap( "n",
	"Qq",
	"<Cmd>bdelete<CR>< Cmd>close<CR>",
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
vim.keymap.set("n", "Kd", function()
  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "d", [["_d]], opts)
  vim.keymap.set("n", "dd", [["_dd]], opts)
  vim.keymap.set("n", "dd", [["_D]], opts)

  vim.defer_fn(function()
    vim.keymap.del("n", "d")
    vim.keymap.del("n", "dd")
    vim.keymap.del("n", "D")
  end, 500)
end, { desc = "Next delete uses black hole" })
keymap("n",
	"KJ",
	"i<CR><Esc>k$",
	{ desc = "Split line at cursor" }
)
keymap(
	'n',
	'KOO',
	"_ddO<Esc>",
	{ desc = "replace with newline no register" }
)
keymap(
	'n',
	'KOK',
	"O<Esc>j",
	{ desc = "newline above, stay in place" }
)
keymap(
	'n',
	'KOJ',
	"o<Esc>k",
	{ desc = "newline below, stay in place" }
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
	'ggVGy`"',
	{ desc = "Yank entire buffer without moving" }
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

local comment = require("custom_macros")

vim.keymap.set("n", "X", comment.toggle_comment, { desc = "Toggle comment (filetype-aware)" })

-- swap bindings for ; and : based on use
keymap("n",
	":",
	";",
	{ noremap= true, desc = "swap colon types based on use" }
)
keymap("n",
	";",
	":",
	{ noremap= true, desc = "swap colon types based on use" }
)

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
