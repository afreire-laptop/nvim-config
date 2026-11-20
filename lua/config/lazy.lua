-- Bootstrap lazy.nvim (unchanged from the LazyVim starter).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim first, then its extras, then our own plugins: LazyVim warns about any other order.
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Extras are declared here rather than through :LazyExtras (lazyvim.json), so the
    -- set is reproducible from this file. Order follows LazyVim's own priorities.
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.test.core" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.typescript.biome" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.ai.claudecode" },

    { import = "plugins" },
  },
  defaults = {
    -- Only LazyVim's own plugins lazy-load; ours load at startup unless they say otherwise.
    lazy = false,
    -- Track each plugin's latest commit; lazy-lock.json pins the exact commits in use.
    version = false,
  },
  install = { colorscheme = { "synthweave", "habamax" } },
  checker = { enabled = true, notify = false },
  -- No plugin here needs luarocks.
  rocks = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})
