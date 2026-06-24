-- lua/xsmd/init.lua

---@class Xsmd
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
