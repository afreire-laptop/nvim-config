-- Everforest, to match Ghostty's "Everforest Dark Hard" theme. Ghostty paints
-- the hard variant's bg_dim (#1e2326) as its background, so a transparent
-- Neovim background shows exactly that colour.
return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_transparent_background = 1
      vim.g.everforest_better_performance = 1
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "everforest" } },
}
