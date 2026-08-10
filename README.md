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

Blink merges config on every `setup()` call, so this works before or after your
own `blink.cmp.setup()`; if you set `completion.trigger` yourself, your values
win.

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
