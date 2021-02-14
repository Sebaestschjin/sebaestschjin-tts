local Object = require("sebaestschjin-tts.Object")
local ObjectState = require("sebaestschjin-tts.ObjectState")
local TableUtil = require("sebaestschjin-tts.TableUtil")
local WrappedContainer = require("sebaestschjin-tts.WrappedContainer")
local WrappedObject = require("sebaestschjin-tts.WrappedObject")

---@class seb_WrappedZone : seb_WrappedContainer

---@class seb_WrappedZone_static : seb_WrappedZone
---@overload fun(data: tts__ScriptingTrigger): seb_WrappedZone
local WrappedZone = {}

setmetatable(WrappedZone, TableUtil.merge(getmetatable(WrappedContainer), {
    __call = function(_, zone)
        local self = --[[---@type seb_WrappedZone]] WrappedContainer(zone.getData())

        ---@type tts__ScriptingTrigger
        local internal = zone

        ---@param obj tts__Object
        ---@return tts__ObjectState
        local function toData(obj)
            return obj.getData()
        end

        ---@return tts__ObjectState[]
        function self.containedObjectsData()
            return TableUtil.map(--[[---@not nil]] internal.getObjects(), toData)
        end

        return self
    end
}))

return WrappedZone
