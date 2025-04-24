local M = {}

---@alias DefaultColorscheme
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

---@class Config
---@field custom string | string[] | nil Custom colorschemes in order that they should be tried to be applied
---@field fallback DefaultColorscheme Default colorscheme to fall back on
---@field silent boolean | nil Whether to ignore all logs

---@type Config
M.default_config = {
    fallback = 'default',
    silent = false
}

---@param colorscheme string
function M.apply_colorscheme(colorscheme)
    local status, _ = pcall(vim.cmd.colorscheme, colorscheme)
    return status
end

--- Apply the colorschemes
---@param opts Config
function M.setup(opts)
    local config = vim.tbl_deep_extend('force', M.default_config, opts)

    -- Make config.custom always be a string[]
    ---@type string[]
    ---@diagnostic disable-next-line: assign-type-mismatch -- The expression type is `string[]`
    local colorschemes = (type(config.custom) == 'string' and { config.custom } or config.custom) or {}
    table.insert(colorschemes, config.fallback)


    -- Apply custom colorschemes
    ---@type string[]
    local failed = {}
    ---@type string | nil
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
