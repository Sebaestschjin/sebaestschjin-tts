local TableUtils = require('ge_tts.TableUtils')
local GeLogger = require('ge_tts.Logger')

---@class se_tts__Logger : ge_tts__Logger

---@class se_tts__static_Logger : ge_tts__static_Logger
---@overload fun(url: string): se_tts__Logger
local Logger = {}

---@type table<number, string>
local levelPrefixes = {
    [GeLogger.ERROR] = 'ERROR: ',
    [GeLogger.WARNING] = 'WARNING: ',
    [GeLogger.INFO] = 'INFO: ',
    [GeLogger.DEBUG] = 'DEBUG: ',
    [GeLogger.VERBOSE] = 'VERBOSE: ',
}

local levelColors = {
    [GeLogger.ERROR] = 'Red',
    [GeLogger.WARNING] = 'Yellow',
    [GeLogger.INFO] = 'Blue',
}

setmetatable(Logger, TableUtils.merge(getmetatable(GeLogger), {
    __call = function()
        local self = GeLogger()

        ---@param message string
        ---@param level ge_tts__Logger_LogLevel
        function self.log(message, level)
            printToAll(levelPrefixes[level] .. message, levelColors[level])
        end

        return self
    end,
    __index = GeLogger,
}))

local logger = Logger()

local function buildMessage(...)
    local args = table.pack(...)
    for i = 1, args.n do
        args[i] = logString(args[i])
    end
    return string.format(table.unpack(args))
end

function Logger.error(...)
    if logger.getFilterLevel() >= GeLogger.ERROR then
        logger.log(buildMessage(...), GeLogger.ERROR)
    end
end

function Logger.warn(...)
    if logger.getFilterLevel() >= GeLogger.WARNING then
        logger.log(buildMessage(...), GeLogger.WARNING)
    end
end

function Logger.info(...)
    if logger.getFilterLevel() >= GeLogger.INFO then
        logger.log(buildMessage(...), GeLogger.INFO)
    end
end

function Logger.debug(...)
    if logger.getFilterLevel() >= GeLogger.DEBUG then
        logger.log(buildMessage(...), GeLogger.DEBUG)
    end
end

function Logger.verbose(...)
    if logger.getFilterLevel() >= GeLogger.VERBOSE then
        logger.log(buildMessage(...), GeLogger.VERBOSE)
    end
end

return Logger
