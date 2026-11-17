-- Options are loaded before lazy.nvim starts.
-- LazyVim's defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Format with Prettier only in projects that have a Prettier config. Biome's
-- formatter already runs only where a biome.json(c) exists, so each project
-- keeps the formatter it declares.
vim.g.lazyvim_prettier_needs_config = true

-- Language providers nothing in this config uses.
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
