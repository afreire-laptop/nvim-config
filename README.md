# nvim-config

My Neovim configuration, built on [LazyVim](https://www.lazyvim.org/).

## Requirements

- Neovim and the tools in [LazyVim's requirements](https://www.lazyvim.org/)

## Install

Move any existing config aside, then clone into `~/.config/nvim` and start
Neovim:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/afreire-laptop/nvim-config.git ~/.config/nvim
nvim
```

lazy.nvim installs the plugins on first start. `:Lazy restore` checks out the
exact versions pinned in `lazy-lock.json`.

## What it adds to LazyVim

- Extras for TypeScript, Biome, Prettier, ESLint, Tailwind, Python, Rust, Go,
  debugging, testing, declared in
  [`lua/config/lazy.lua`](lua/config/lazy.lua).
- `<leader>ay` copies an `@file:line` reference to the current line or
  selection, for pasting into a coding agent.
- Inlay hints show on the cursor line only; `<leader>uH` shows them on every
  line ([`inlay_hints.lua`](lua/config/inlay_hints.lua)).
- Debugging in Chrome against a dev server, and attaching to Node by inspector
  port ([`dap.lua`](lua/plugins/dap.lua)).
- Vitest through neotest, including tests in `.tsx` files
  ([`test.lua`](lua/plugins/test.lua)).

Comments beside each change explain what it does and why.

## License

[Apache-2.0](LICENSE), the license of the
[LazyVim starter](https://github.com/LazyVim/starter) this config began from.
