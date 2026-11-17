-- Keymaps are loaded on the VeryLazy event.
-- LazyVim's defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Copy a reference to the current line or selection, for pasting into any
-- coding agent (Codex, Pi, or Claude without /ide).
local function copy_ref(ref)
  vim.fn.setreg("+", ref)
  vim.notify("Copied " .. ref)
end

vim.keymap.set("n", "<leader>ay", function()
  copy_ref(("@%s:%d"):format(vim.fn.expand("%:."), vim.fn.line(".")))
end, { desc = "Copy @file:line" })

vim.keymap.set("x", "<leader>ay", function()
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  copy_ref(("@%s:%d-%d"):format(vim.fn.expand("%:."), first, last))
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
end, { desc = "Copy @file:lines" })
