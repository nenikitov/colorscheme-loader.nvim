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

---@type Config
M.default_config = {
    fallback = 'default',
}

---@param colorscheme string
function M.try_apply_colorscheme(colorscheme)
    ---@diagnostic disable-next-line: param-type-mismatch -- `vim.cmd` is indeed callable
    local status, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
    return status
end

--- Apply the colorschemes
---@param opts Config
function M.setup(opts)
    local config = vim.tbl_deep_extend('force', M.default_config, opts)

    -- Make `config.custom` only `string[]`
    if config.custom == nil then
        config.custom = {}
    elseif type(config.custom) == 'string' then
        ---@diagnostic disable-next-line: assign-type-mismatch -- `config.custom` is `string`
        config.custom = { config.custom }
    end

    -- Try to apply custom
    if #config.custom ~= 0 then
        ---@type string[]
        local failed = {}
        ---@type string | nil
        local succeeded = nil

        ---@diagnostic disable-next-line: param-type-mismatch -- `config.custom` is `string[]`
        for _, c in ipairs(config.custom) do
            if M.try_apply_colorscheme(c) then
                succeeded = c
                break
            else
                table.insert(failed, c)
            end
        end

        if #failed ~= 0 then
            vim.notify(
                'Colorschemes '
                    .. vim.inspect(failed)
                    .. ' could not be loaded, falling back to '
                    .. vim.inspect(succeeded or config.fallback),
                vim.log.levels.WARN
            )
        end
        if succeeded then
            return
        end
    end

    -- Apply default
    M.try_apply_colorscheme(config.fallback)
end

return M
