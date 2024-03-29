local TableUtils = require('ge_tts.TableUtils')
local GeLogger = require('ge_tts.Logger')

---@class seb_Logger : ge_tts__Logger

---@class seb_Logger_static
---@overload fun(): seb_Logger
local Logger = {}

Logger.ERROR = GeLogger.ERROR
Logger.WARNING = GeLogger.WARNING
Logger.INFO = GeLogger.INFO
Logger.DEBUG = GeLogger.DEBUG
Logger.VERBOSE = GeLogger.VERBOSE

---@type table<number, string>
local levelPrefixes = {
  [GeLogger.ERROR] = 'ERROR: ',
  [GeLogger.WARNING] = 'WARNING: ',
  [GeLogger.INFO] = 'INFO: ',
  [GeLogger.DEBUG] = 'DEBUG: ',
  [GeLogger.VERBOSE] = 'VERBOSE: ',
}

---@type table<ge_tts__Logger_LogLevel, string>
local levelColors = {
  [GeLogger.ERROR] = 'Red',
  [GeLogger.WARNING] = 'Yellow',
  [GeLogger.INFO] = 'Blue',
}

--- Logger instances registered on other objects.
---@type GUID[]
local objectLoggers = {}

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

  local success, result = pcall(function()
    return string.format(table.unpack(args))
  end)

  if success then
    return result
  end

  return table.unpack(args)
end

---@param functionName string
local function notifyObjectLoggers(functionName, parameter)
  if self == Global then
    for i = #objectLoggers, 1, -1 do
      local objectLogger = objectLoggers[i]
      local obj = getObjectFromGUID(objectLogger)
      if obj then
        (--[[---@not nil]] obj).call(functionName, parameter)
      else
        table.remove(objectLoggers, i)
      end
    end
  end
end

---@param level ge_tts__Logger_LogLevel
function Logger.setLevel(level)
  logger.setFilterLevel(level)
  notifyObjectLoggers("__set_logger_level", level)
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

function Logger.assert(value, ...)
  if not value then
    logger.assert(value, buildMessage(...))
  end
end

if self == Global then
  ---@param guid GUID
  _G.__register_object_logger = function(guid)
    table.insert(objectLoggers, guid)
  end
  _G.__logger_exists = true
else
  if Global.getVar("__logger_exists") then
    Global.call("__register_object_logger", self.getGUID())
  end
  _G.__set_logger_level = function(level)
    Logger.setLevel(level)
  end
end

return Logger
