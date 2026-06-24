-- lua/xsmd/init.lua

local M = {}
local config_mod = require("xsmd.config")

---@class XsmdUserConfig
---@field cmd? string[] Override the default command to launch the server

---@param opts? XsmdUserConfig
function M.setup(opts)
	opts = opts or {}

	local lsp_config = config_mod.get_default_config()

	if opts.cmd then
		lsp_config.cmd = opts.cmd
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		callback = function(args)
			vim.lsp.start(lsp_config, { bufnr = args.buf })
		end,
	})
end

return M
