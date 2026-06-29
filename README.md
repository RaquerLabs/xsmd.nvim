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

## blink.cmp plugin

This can also be used as a blink.cmp plugin:

```lua
require("blink.cmp").setup({
  completion = {
    documentation = { auto_show = false },
    menu = {
      auto_show = false,
    },
  }
})
```

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
    title = "XSMD",
    items = items,
    format = "file",
  })
end, { desc = "Open XSMD picker" })
```
