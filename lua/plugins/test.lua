-- Vitest through neotest (test.core extra). LazyVim ships no Vitest adapter,
-- so this uses the community one.
return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "marilari88/neotest-vitest" },
    opts = { adapters = { ["neotest-vitest"] = {} } },
  },
}
