-- File pickers (<leader>ff, <leader><space>, <leader>fF) list dotfiles and
-- dot-directories too. Git-ignored paths stay out: <a-i> in the picker toggles
-- them, and a project's .fdignore can re-include one (e.g. `!/.local/`).
return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = { hidden = true },
        },
      },
    },
  },
}
