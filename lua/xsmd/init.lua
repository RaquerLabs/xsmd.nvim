-- lua/xsmd/init.lua

---@class Xsmd
local M = {}
local config_mod = require("xsmd.config")

---@class XsmdBlinkConfig
---@field auto_configure? boolean When true and blink.cmp is installed, apply
---  xsmd's recommended completion trigger config: `show_on_blocked_trigger_characters = {}`
---  keeps the completion menu open on space so multi-word note titles can be
---  searched. Defaults to false.

---@class XsmdUserConfig
---@field cmd? string[] Override the default command to launch the server
---@field blink? XsmdBlinkConfig

--- Apply xsmd's recommended blink.cmp config. Safe to call before or after the
--- user's own `blink.cmp.setup()`: blink merges config on every setup() call.
local function configure_blink()
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then return end

  blink.setup({
    completion = {
      trigger = {
        -- Blink closes the completion menu on space by default. Unblocking it
        -- lets the query contain spaces so the server's multi-word fuzzy
        -- matching can find titles like "this file".
        show_on_blocked_trigger_characters = {},
      },
    },
  })
end

---@param opts? XsmdUserConfig
function M.setup(opts)
  opts = opts or {}

  if opts.blink and opts.blink.auto_configure then configure_blink() end

  local lsp_config = config_mod.get_default_config()

  if opts.cmd then lsp_config.cmd = opts.cmd end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(args)
      local root_markers = lsp_config.root_markers or { "xsmd.toml", ".git" }
      local root_dir = vim.fs.root(args.buf, root_markers)
      if not root_dir or root_dir == "" then
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        if bufname ~= "" then
          root_dir = vim.fs.dirname(bufname)
        else
          root_dir = vim.uv.cwd()
        end
      end

      local config = vim.tbl_deep_extend("force", {}, lsp_config, { root_dir = root_dir })
      vim.lsp.start(config, { bufnr = args.buf })
    end,
  })
end

return M
