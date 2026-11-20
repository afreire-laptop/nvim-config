-- Inlay hints (the grey types and parameter names an LSP server adds) only on
-- the cursor line, and none while typing. Neovim has no option for this: it
-- draws hints where the LSP spec places them (neovim/neovim#28261). So this
-- takes over the hint responses from the built-in handler, which then draws
-- nothing, and draws the cursor line's hints itself. Moving the cursor redraws
-- from the kept response, with no new request. The built-in can't be fed fewer
-- hints instead: it redraws a line only after the buffer changes.
-- setup() runs from autocmds.lua; the <leader>uH toggle for every line is in
-- keymaps.lua, which loads after Snacks. <leader>uh still turns hints off.
local M = {}

local METHOD = "textDocument/inlayHint"
local ns = vim.api.nvim_create_namespace("inlay_hints_cursor_line")

local show_all = false
---@type table<integer, table<integer, { by_line: table<integer, lsp.InlayHint[]>, version: integer }>>
local responses = {}
---@type table<integer, integer|false>
local drawn_line = {}
---@type lsp.Handler
local builtin

---@param bufnr integer
---@return integer|false line 0-based, or false when no line shows hints
local function cursor_line(bufnr)
  if bufnr ~= vim.api.nvim_get_current_buf() or vim.fn.mode():match("^[iR]") then
    return false
  end
  return vim.api.nvim_win_get_cursor(0)[1] - 1
end

---@param hint lsp.InlayHint
local function label_of(hint)
  if type(hint.label) == "string" then
    return hint.label
  end
  return table.concat(vim.tbl_map(function(part)
    return part.value
  end, hint.label))
end

-- Drawn as the built-in does: hints at one position share an inline mark.
---@param bufnr integer
---@param client vim.lsp.Client
---@param lnum integer
---@param hints lsp.InlayHint[]
local function draw_line(bufnr, client, lnum, hints)
  local text = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
  local chunks_at = {} ---@type table<integer, [string, string?][]>
  for _, hint in ipairs(hints) do
    local col = vim.str_byteindex(text, client.offset_encoding, hint.position.character, false)
    local chunks = chunks_at[col] or {}
    if hint.paddingLeft then
      chunks[#chunks + 1] = { " " }
    end
    chunks[#chunks + 1] = { label_of(hint), "LspInlayHint" }
    if hint.paddingRight then
      chunks[#chunks + 1] = { " " }
    end
    chunks_at[col] = chunks
  end
  for col, chunks in pairs(chunks_at) do
    vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, col, { virt_text = chunks, virt_text_pos = "inline" })
  end
end

---@param bufnr integer
---@param line integer|false
local function render(bufnr, line)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  drawn_line[bufnr] = line
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  if not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
    return
  end
  for client_id, response in pairs(responses[bufnr] or {}) do
    local client = vim.lsp.get_client_by_id(client_id)
    -- After an edit the positions are stale until the server's next response.
    if client and response.version == vim.lsp.util.buf_versions[bufnr] then
      for lnum, hints in pairs(response.by_line) do
        if show_all or lnum == line then
          draw_line(bufnr, client, lnum, hints)
        end
      end
    end
  end
end

---@type lsp.Handler
local function on_inlay_hints(err, result, ctx, config)
  local bufnr = ctx.bufnr
  if err or not bufnr then
    return builtin(err, result, ctx, config)
  end
  if not vim.api.nvim_buf_is_loaded(bufnr) or ctx.version ~= vim.lsp.util.buf_versions[bufnr] then
    return
  end
  local by_line = {}
  for _, hint in ipairs(result or {}) do
    local lnum = hint.position.line
    by_line[lnum] = by_line[lnum] or {}
    table.insert(by_line[lnum], hint)
  end
  responses[bufnr] = responses[bufnr] or {}
  responses[bufnr][ctx.client_id] = { by_line = by_line, version = ctx.version }
  render(bufnr, cursor_line(bufnr))
end

function M.setup()
  builtin = vim.lsp.handlers[METHOD]
  vim.lsp.handlers[METHOD] = on_inlay_hints

  local group = vim.api.nvim_create_augroup("inlay_hints_cursor_line", { clear = true })
  vim.api.nvim_create_autocmd({ "CursorMoved", "InsertLeave", "BufEnter" }, {
    group = group,
    callback = function(ev)
      local line = cursor_line(ev.buf)
      if not show_all and line ~= drawn_line[ev.buf] then
        render(ev.buf, line)
      end
    end,
  })
  vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave" }, {
    group = group,
    callback = function(ev)
      if not show_all and drawn_line[ev.buf] ~= false then
        render(ev.buf, false)
      end
    end,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    group = group,
    callback = function(ev)
      if responses[ev.buf] then
        responses[ev.buf][ev.data.client_id] = nil
        render(ev.buf, drawn_line[ev.buf] or false)
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(ev)
      responses[ev.buf], drawn_line[ev.buf] = nil, nil
    end,
  })

  -- <leader>uh disables hints without an event; the built-in redraws the
  -- buffer when it does, so clear this layer on that redraw.
  vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, _, bufnr)
      if
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        and #vim.api.nvim_buf_get_extmarks(bufnr, ns, 0, -1, { limit = 1 }) > 0
      then
        vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
      end
      return false
    end,
  })
end

---@return boolean
function M.all_lines()
  return show_all
end

---@param state boolean
function M.set_all_lines(state)
  show_all = state
  for bufnr in pairs(responses) do
    render(bufnr, cursor_line(bufnr))
  end
end

return M
