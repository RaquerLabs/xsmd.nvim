# xsmd.nvim

This is a plugin that provides an easy way to use
[xsmd](https://github.com/RaquerLabs/xsmd/)+[blink.cmp](https://github.com/saghen/blink.cmp)
in neovim.

## Installation

You can use nvim's package manager to install this plugin.

```lua
vim.pack.add({
  { src = "https://github.com/RaquerLabs/xsmd.nvim" },
})
require("xsmd").setup()
```

## blink.cmp

xsmd completions arrive through blink's built-in `lsp` source — the server
advertises `[`, `(`, and space as its trigger characters, so no custom source
is needed:

```lua
require("blink.cmp").setup({
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
})
```

Blink closes the completion menu on space by default. To search multi-word
note titles (e.g. `[this file`), unblock space as a trigger character:

```lua
require("blink.cmp").setup({
  completion = {
    trigger = {
      -- Keep the menu open on space so the query can span multiple words.
      -- This replaces the default { " ", "\n", "\t" } list entirely.
      show_on_blocked_trigger_characters = {},
    },
  },
})
```

Or let the plugin apply that config for you when blink.cmp is installed:

```lua
require("xsmd").setup({
  blink = { auto_configure = true },
})
```

The plugin uses blink's config callable (`blink.cmp.config`) rather than
`setup()`, because blink.cmp v2 `setup()` is one-shot — only the first call
applies config. The callable merges at any time, so ordering vs. your own
`blink.cmp.setup()` doesn't matter; if you've customized
`show_on_blocked_trigger_characters` yourself, the plugin leaves it alone.

Note for blink.cmp v2: `Blink.setup()` ignores every call after the first —
don't call it twice (e.g. a bare `Blink.setup()` followed by a configured one
silently drops the configured call).

## pickers

You can also use pickers:

```lua
vim.keymap.set("n", "<LocalLeader>f", function()
  local lines = vim.fn.systemlist("xsmd list")

  local items = {}
  for _, line in ipairs(lines) do
    if line ~= "" then
      table.insert(items, {
        text = line,
        file = line,
      })
    end
  end

  Snacks.picker.pick({
    title = "xsmd Picker",
    items = items,
    format = "file",
    confirm = function(picker, item)
      picker:close() -- Close the picker UI safely
      if item and item.file then
        local markdown_link = string.format("[](/%s)", item.file)
        vim.api.nvim_put({ markdown_link }, "c", true, true)
      end
    end,
  })
```
