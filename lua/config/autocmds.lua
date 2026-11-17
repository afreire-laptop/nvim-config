-- Autocmds are loaded on the VeryLazy event.
-- LazyVim's defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Reload files that a coding agent changed on disk. LazyVim checks on
-- FocusGained, which misses edits an agent makes while this pane keeps focus,
-- so also check when entering a buffer and after the cursor rests. Insert mode
-- is left out so the "file changed" prompt never interrupts typing.
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("agent_checktime", { clear = true }),
  callback = function()
    if vim.bo.buftype == "" and vim.fn.getcmdwintype() == "" and vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})
