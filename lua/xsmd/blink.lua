local M = {}

function M.new() return setmetatable({}, { __index = M }) end

function M:get_trigger_characters() return { " ", "-", "_" } end

function M:get_completions(_, callback)
  -- We only want to run this if the xsmd LSP is attached to the current buffer
  local clients = vim.lsp.get_clients({ bufnr = 0, name = "xsmd" })
  if #clients == 0 then
    return callback() -- No xsmd LSP, return nothing
  end

  local client = clients[1]
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

  -- Use the colon (:) to call the request method on the client object
  client:request("textDocument/completion", params, function(err, result)
    if err or not result then return callback() end

    -- Extract the items (LSPs can return a list or a dict containing 'items')
    local items = result.items or result

    -- Pass the LSP's items directly back to blink.cmp
    callback({
      is_incomplete_forward = false,
      is_incomplete_backward = false,
      items = items,
    })
  end, 0)
end

return M
