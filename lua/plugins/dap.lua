return {
  -- lang.python sets up nvim-dap-python but doesn't install its adapter.
  { "mason-org/mason.nvim", opts = { ensure_installed = { "debugpy" } } },

  -- Attach to any Node process started with --inspect, such as `next dev --inspect`
  -- (its server listens on 9229) or `vitest --inspect-brk`. This runs after the
  -- lang.typescript extra's opts, so it adds to LazyVim's "Launch file" and "Attach".
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      local attach_port = {
        type = "pwa-node",
        request = "attach",
        name = "Attach to Node inspector (port)",
        port = function()
          return tonumber(vim.fn.input("Inspector port: ", "9229"))
        end,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        skipFiles = { "<node_internals>/**", "**/node_modules/**" },
        resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
      }
      for _, ft in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
        dap.configurations[ft] = dap.configurations[ft] or {}
        table.insert(dap.configurations[ft], attach_port)
      end
    end,
  },
}
