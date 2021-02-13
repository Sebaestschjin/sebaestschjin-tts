local Object = require("sebaestschjin-tts.Object")
local ObjectState = require("sebaestschjin-tts.ObjectState")
local TableUtil = require("sebaestschjin-tts.TableUtil")
local WrappedObject = require("sebaestschjin-tts.WrappedObject")

---@class seb_WrappedContainer : seb_WrappedObject

---@class seb_WrappedContainer_static : seb_WrappedContainer
---@overload fun(data: tts__ContainerState): seb_WrappedContainer
---@overload fun(data: tts__ContainerState, index: number): seb_WrappedContainer
local WrappedContainer = {}

setmetatable(WrappedContainer, TableUtil.merge(getmetatable(WrappedObject), {
    __call = function(_, data, index)
        local self = --[[---@type seb_WrappedContainer]] WrappedObject(data, index)

        ---@type tts__ContainerState
        local internal = data

        ---@param objectState tts__ObjectState
        ---@param containedIndex number
        ---@return seb_WrappedObject
        local function wrapContainedObject(objectState, containedIndex)
            if ObjectState.isContainer(objectState) then
                return WrappedContainer(--[[---@type tts__ContainerState]] objectState, containedIndex)
            end
            return WrappedObject(objectState, containedIndex)
        end

        ---@return seb_WrappedObject[]
        function self.getObjects()
            if internal.ContainedObjects then
                return TableUtil.map(--[[---@not nil]] internal.ContainedObjects, wrapContainedObject)
            end
            return {}
        end

        return self
    end
}))

return WrappedContainer