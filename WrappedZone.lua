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

        ---@param object tts__Object
        ---@param containedIndex number
        ---@return seb_WrappedObject
        local function wrapContainedObject(object, containedIndex)
            if Object.isContainer(object) then
                return WrappedContainer(--[[---@type tts__ContainerState]] object.getData(), containedIndex)
            end
            return WrappedObject(object.getData(), containedIndex)
        end

        ---@return seb_WrappedObject[]
        function self.getObjects()
            return TableUtil.map(--[[---@not nil]] internal.getObjects(), wrapContainedObject)
        end

        return self
    end
}))

return WrappedZone
