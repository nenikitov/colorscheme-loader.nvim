local M = {}

---@alias colorscheme_loader.DefaultColorscheme
--- | 'blue'
--- | 'darkblue'
--- | 'default'
--- | 'delek'
--- | 'desert'
--- | 'elflord'
--- | 'evening'
--- | 'habamax'
--- | 'industry'
--- | 'koehler'
--- | 'lunaperche'
--- | 'morning'
--- | 'murphy'
--- | 'pablo'
--- | 'peachpuff'
--- | 'quiet'
--- | 'retrobox'
--- | 'ron'
--- | 'shine'
--- | 'slate'
--- | 'sorbet'
--- | 'torte'
--- | 'wildcharm'
--- | 'zaibatsu'
--- | 'zellner'

---@class colorscheme_loader.Opts
---@field custom? string | string[] Custom colorschemes in order that they should be tried to be applied
---@field fallback? colorscheme_loader.DefaultColorscheme Default colorscheme to fall back on
---@field silent? boolean Whether to ignore the notification when fallback is used

---@class colorscheme_loader.Config: colorscheme_loader.Opts
---@field custom string | string[]
---@field fallback colorscheme_loader.DefaultColorscheme
---@field silent boolean


---@type colorscheme_loader.Config
M.default_config = {
    custom = {},
    fallback = 'default',
    silent = false,
}

---@param colorscheme string
---@return boolean
function M.apply_colorscheme(colorscheme)
    local status, _ = pcall(vim.cmd.colorscheme, colorscheme)
    return status
end

--- Apply the colorschemes
---@param opts? colorscheme_loader.Opts
function M.setup(opts)
    local config = vim.tbl_deep_extend('force', M.default_config, opts or {})

    -- Every colorscheme to try, in order, ending with the fallback
    ---@type string[]
    local colorschemes = {}
    if type(config.custom) == 'string' then
        table.insert(colorschemes, config.custom)
    else
        vim.list_extend(colorschemes, config.custom)
    end
    table.insert(colorschemes, config.fallback)

    -- Apply custom colorschemes
    ---@type string[]
    local failed = {}
    ---@type string?
    local succeeded = nil

    for _, c in ipairs(colorschemes) do
        if M.apply_colorscheme(c) then
            succeeded = c
            break
        else
            table.insert(failed, c)
        end
    end

    if #failed ~= 0 and not config.silent then
        vim.notify(
            'Colorschemes '
                .. vim.inspect(failed)
                .. ' could not be loaded, falling back to '
                .. vim.inspect(succeeded),
            vim.log.levels.WARN
        )
    end
end

return M
