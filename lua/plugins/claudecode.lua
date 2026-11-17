-- Claude Code runs in its own Ghostty split or tmux pane, not inside Neovim.
-- claudecode.nvim still starts its IDE server and writes ~/.claude/ide/<port>.lock,
-- so `/ide` in that Claude session connects to this Neovim (selection, open
-- files, diagnostics, and diffs to accept with :w or reject with :q).
return {
  {
    "coder/claudecode.nvim",
    -- The LazyVim extra loads only on its <leader>a keys; start the server at launch
    -- so Claude can find Neovim straight away.
    lazy = false,
    opts = {
      terminal = { provider = "none" },
    },
  },
}
