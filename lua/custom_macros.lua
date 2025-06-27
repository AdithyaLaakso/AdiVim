-- ~/lua/mymacros/comment.lua
local M = {}

local comment_map = {
  lua = "--",
  python = "#",
  rust = "//",
  c = "//",
  cpp = "//",
  javascript = "//",
  typescript = "//",
  sh = "#",
  bash = "#",
  vim = '"',
}

M.toggle_comment = function()
  local ft = vim.bo.filetype
  local comment = comment_map[ft] or "//"
  local line = vim.api.nvim_get_current_line()

  if line:match("^%s*" .. vim.pesc(comment)) then
    -- Uncomment
    line = line:gsub("^%s*" .. vim.pesc(comment) .. "%s?", "", 1)
  else
    -- Comment
    line = comment .. " " .. line
  end

  vim.api.nvim_set_current_line(line)
end

return M
