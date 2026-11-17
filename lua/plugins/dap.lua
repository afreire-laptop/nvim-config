return {
  -- lang.python sets up nvim-dap-python but doesn't install its adapter.
  { "mason-org/mason.nvim", opts = { ensure_installed = { "debugpy" } } },

  -- Two additions to the lang.typescript extra's "Launch file" and "Attach" (this
  -- runs after its opts, so it appends to them):
  -- * Chrome: debug browser-side code (client components, hooks, event handlers)
  --   against a running dev server, in a Chrome with its own debug profile.
  -- * Node attach by port: server-side code, from any process started with
  --   --inspect, such as `next dev --inspect` (9229) or `vitest --inspect-brk`.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      local chrome_launch = {
        type = "pwa-chrome",
        request = "launch",
        name = "Launch Chrome (dev server URL)",
        url = function()
          return vim.fn.input("Dev server URL: ", "http://localhost:3000")
        end,
        webRoot = "${workspaceFolder}",
        sourceMaps = true,
      }
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
      -- VS Code defaults a browser config's webRoot to the workspace folder;
      -- standalone js-debug doesn't, so a .vscode/launch.json Chrome config
      -- without one would bind no breakpoints. Apply the same default here.
      dap.listeners.on_config["browser-webroot"] = function(config)
        local browser = { "chrome", "pwa-chrome", "msedge", "pwa-msedge" }
        if config.webRoot == nil and vim.tbl_contains(browser, config.type) then
          config = vim.deepcopy(config)
          config.webRoot = "${workspaceFolder}"
        end
        return config
      end

      for _, ft in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
        dap.configurations[ft] = dap.configurations[ft] or {}
        table.insert(dap.configurations[ft], chrome_launch)
        table.insert(dap.configurations[ft], attach_port)
      end
    end,
  },
}
