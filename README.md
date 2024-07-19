kokokoko.nvim
================================================================================
Something to visualize cursor moving.

I had already found a similar plugin.

but I can't understund that plugin code.

So, DIY!

Thanks.

Special Feature
--------------------------------------------------------------------------------
- Simple code for studying neovim lua plugin
- Move(Jump) across folding lines

Install
--------------------------------------------------------------------------------
### for lazy.nvim

```lua
{
  "tyamaz/kokokoko.nvim",
  config = function()
    require("kokokoko").setup()
  end
}
```



