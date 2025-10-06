# colorscheme-loader.nvim

Simple nvim plugin to set colorschemes

## Usage

- [`lazy.nvim`](https://github.com/folke/lazy.nvim)
    ```lua
    return {
        {
            'nenikitov/colorscheme-loader.nvim',
            opts = {
                -- Custom colorscheme to load
                -- Or array for fallbacks
                -- Optional if you want to apply a default colorscheme
                custom = 'horizon',
                -- Extra fallback from default NeoVim colorschemes
                fallback = 'slate',
                -- Whether to ignore the notification when fallback is used
                silent = false,
            },
            -- `init` is called before all other plugins, so no need to set `priority`
            init = function(self)
                require('colorscheme_loader').setup(self.opts)
            end,
            -- `config` not needed, is configured in `init`
            config = function() end,
        },
        -- All your colorscheme plugins, along with their `config` functions (if needed) go here
        'akinsho/horizon.nvim',
    }
    ```
