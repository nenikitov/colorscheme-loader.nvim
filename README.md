# colorscheme-loader.nvim

Simple nvim plugin to set colorschemes

## Usage

- [`lazy.nvim`](https://github.com/folke/lazy.nvim)
    ```lua
    return {
        'nenikitov/colorscheme-loader.nvim',
        dependencies = {
            -- All your colorschemes along with their `setup` functions (if needed) go here
            'akinsho/horizon.nvim'
        },
        -- !! Important !! Since all colorschemes are listed as dependencies
        -- The priority of this plugin is propagated
        priority = 1000,
        opts = {
            -- Custom colorscheme to load
            -- Or array for fallbacks
            -- Optional if you want to apply a default colorscheme
            custom = 'horizon',
            -- Extra fallback from default NeoVim colorschemes
            fallback = 'slate'
        }
    }
    ```
