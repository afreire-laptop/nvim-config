-- Vitest through neotest (test.core extra). LazyVim ships no Vitest adapter,
-- so this uses the community one.
return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "marilari88/neotest-vitest" },
    opts = function(_, opts)
      -- Work around nvim-neotest/neotest#631 (and #630): neotest finds tests by
      -- parsing files in a child Neovim started with `-u NONE`. That child lacks
      -- the filetype-to-parser aliases nvim-treesitter registers, such as
      -- typescriptreact -> tsx, so it finds no tests in .tsx files. Copy this
      -- Neovim's aliases into the child when it starts. Remove once #631 is fixed.
      local subprocess = require("neotest.lib.subprocess")
      if not subprocess._workaround_631 then
        subprocess._workaround_631 = true
        local init = subprocess.init
        subprocess.init = function(...)
          init(...)
          if not subprocess.enabled() then
            return
          end
          local ok, err = pcall(function()
            local aliases = {}
            for _, ft in ipairs(require("nio").fn.getcompletion("", "filetype")) do
              local lang = vim.treesitter.language.get_lang(ft)
              if lang and lang ~= ft then
                aliases[ft] = lang
              end
            end
            subprocess.request(
              "nvim_exec_lua",
              "for ft, lang in pairs(...) do vim.treesitter.language.register(lang, ft) end",
              { aliases }
            )
          end)
          if not ok then
            vim.schedule(function()
              vim.notify("neotest #631 workaround failed: " .. tostring(err), vim.log.levels.WARN)
            end)
          end
        end
      end

      opts.adapters = opts.adapters or {}
      opts.adapters["neotest-vitest"] = {}
    end,
  },
}
