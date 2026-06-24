local M = {}

---@return vim.lsp.Config
function M.get_default_config()
	return {
		cmd = { "xsmd" },
		filetypes = { "markdown" },
		root_markers = { "xsmd.toml" },
		settings = {},
		on_attach = function(client, bufnr)
			-- Configure native folding right when the LSP attaches to the buffer
			vim.api.nvim_set_option_value("foldmethod", "expr", { buf = bufnr })
			vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.lsp.foldexpr()", { buf = bufnr })
		end,
	}
end

return M
