local M = {}

M.original_blink_regex = nil
M.original_blocked_triggers = nil

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

			-- Dynamically toggle blink.cmp configuration just for this buffer
			local has_blink, blink_config = pcall(require, "blink.cmp.config")
			if has_blink then
				-- Keep a backup of the user's original configurations
				if not M.original_blink_regex then
					M.original_blink_regex = blink_config.completion.keyword.regex
				end
				if not M.original_blocked_triggers then
					M.original_blocked_triggers =
						vim.deepcopy(blink_config.completion.trigger.show_on_blocked_trigger_characters)
				end

				local group = vim.api.nvim_create_augroup("xsmd_blink_toggle_" .. bufnr, { clear = true })

				-- When entering this buffer, allow space in keyword range and triggers
				vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
					buffer = bufnr,
					group = group,
					callback = function()
						blink_config.completion.keyword.regex = "[-_ ]\\|\\k"
						blink_config.completion.trigger.show_on_blocked_trigger_characters = {}
					end,
				})

				-- When leaving this buffer, restore the user's default configurations
				vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
					buffer = bufnr,
					group = group,
					callback = function()
						blink_config.completion.keyword.regex = M.original_blink_regex
						blink_config.completion.trigger.show_on_blocked_trigger_characters = M.original_blocked_triggers
					end,
				})

				-- Apply the settings immediately for the active buffer
				if vim.api.nvim_get_current_buf() == bufnr then
					blink_config.completion.keyword.regex = "[-_ ]\\|\\k"
					blink_config.completion.trigger.show_on_blocked_trigger_characters = {}
				end
			end
		end,
	}
end

return M
