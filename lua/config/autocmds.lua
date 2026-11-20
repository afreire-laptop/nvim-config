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

-- LazyVim turns on wrap and spell checking for markdown (its "wrap_spell"
-- autocmd). Keep the wrap but drop spell: in technical docs the dictionary
-- flags every identifier. This runs after LazyVim's autocmd because it is
-- defined later. <leader>us still toggles spelling for a buffer.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_no_spell", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
})

-- Inlay hints only on the cursor line.
require("config.inlay_hints").setup()
