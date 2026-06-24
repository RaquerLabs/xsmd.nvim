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
