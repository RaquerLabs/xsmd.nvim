local M = {}

M.original_blink_regex = nil
M.original_blocked_triggers = nil

--- Register the debug command so it's available whenever the LSP attaches
local function register_debug_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "XsmdDump", function()
    client:exec_cmd({ command = "xsmd.dumpState", arguments = {} }, { bufnr = bufnr })
    print("Dump command sent to xsmd server!")
  end, { desc = "Dump xsmd server state to log" })
end

---@return vim.lsp.Config
function M.get_default_config()
  return {
    cmd = { "xsmd" },
    filetypes = { "markdown" },
    root_markers = { "xsmd.toml", ".git" },
    settings = {},
    on_attach = function(client, bufnr)
      register_debug_command(client, bufnr)

      local wins = vim.fn.win_findbuf(bufnr) or {}
      if #wins > 0 then
        for _, win in ipairs(wins) do
          vim.api.nvim_set_option_value("foldmethod", "expr", { win = win })
          vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { win = win })
        end
      else
        vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local" })
        vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { scope = "local" })
      end
    end,
  }
end

return M
