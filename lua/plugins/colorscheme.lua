-- Synthweave, a SynthWave '84 style theme: vivid neon colours. The transparent
-- variant leaves the background to Ghostty ("synthweave" paints its own).

-- Synthweave draws split lines (WinSeparator) and inlay hints (LspInlayHint)
-- in a dark purple that barely shows. Split lines take Ghostty's
-- split-divider-color (local.ghostty); hints take the comment colour, a
-- little darker. The theme's `overrides` option can't do this: its
-- synthweave-transparent colorscheme file calls setup() again without them.
local SPLIT_LINE = "#a4a6ed"
local INLAY_HINT = "#777daa" -- Comment (#848bbd) at 90%

return {
  {
    "samharju/synthweave.nvim",
    priority = 1000,
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("synthweave_readable", { clear = true }),
        pattern = "synthweave*",
        callback = function()
          vim.api.nvim_set_hl(0, "WinSeparator", { fg = SPLIT_LINE })
          vim.api.nvim_set_hl(0, "LspInlayHint", { fg = INLAY_HINT })
        end,
      })
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "synthweave-transparent" } },
}
