local M = {}

---@return vim.lsp.Config
function M.get_default_config()
	return {
		cmd = { "xsmd" },
		filetypes = { "markdown" },
		root_markers = { "xsmd.toml", ".git" },
		settings = {},
		on_attach = function(client, bufnr)
			-- Configure native folding right when the LSP attaches to the buffer
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
