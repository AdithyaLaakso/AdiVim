-- Use GPU acceleration
vim.loader.enable()
vim.opt.lazyredraw = true

-- This is vim, bruh
vim.opt.mouse = ""
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("", "<left>", "<nop>", { noremap = true })
vim.keymap.set("", "<right>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<left>", "<nop>", { noremap = true })
vim.keymap.set("i", "<right>", "<nop>", { noremap = true })

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- add the "ur dumb" line
vim.opt.colorcolumn = "80"

-- Disable status line
vim.opt.laststatus = 0

-- Share the default register with the system clipboard
vim.opt.clipboard:append("unnamedplus")

-- Windows sanity
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Enforce tab sanity
vim.opt.tabstop = 2       -- Display a tab character as 2 spaces wide
vim.opt.softtabstop = 2   -- Makes backspace delete 1 tabstop worth
vim.opt.shiftwidth = 2    -- Indent operations use 2 spaces per level
vim.opt.expandtab = false -- KEEP real tabs (don't convert to spaces)

-- General sanity
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.ignorecase = true

-- experimenting with keeping the cursor in the center of the window so that
-- zz is not needed
vim.opt.scrolloff = 999

-- Virtual edits
vim.opt.ve = all

-- Disable insanity (swapfiles smh)
vim.opt.swapfile = false

-- Undo sanity
vim.opt.undofile = true


-- Auto-remove trailing whitespace on save (so as not to be a asshole in git commits)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

--there HAS to be a better way to do this, cuz it should be default
-- Store previous contents of the unnamed register
-- Prevent whitespace-only deletes from overwriting \" register
-- also does not work (fml)
local last_good_register = vim.fn.getreg('"')
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local event = vim.v.event
    local text = event.regcontents and table.concat(event.regcontents, "\n") or ""
    if event.operator == "d" or event.operator == "c" then
      if text:match("^%s*$") then
        vim.fn.setreg('"', last_good_register)
        return
      end
    end
    last_good_register = vim.fn.getreg('"')
  end,
  desc = "Prevent whitespace-only deletes from overwriting \" or + register",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.uss",
  callback = function()
    vim.bo.filetype = "css"
  end,
})

-- Extra-safe custom filetypes
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.uxml",
  callback = function()
    vim.bo.filetype = "html"
  end,
})
