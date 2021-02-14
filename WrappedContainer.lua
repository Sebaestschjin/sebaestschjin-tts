local Search = require("sebaestschjin-tts.Search")
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

        ---@return tts__ObjectState[]
        function self.containedObjectsData()
            return internal.ContainedObjects or {}
        end

        ---@param search seb_Search
        ---@return nil | seb_WrappedObject
        function self.findObject(search)
            local foundData, foundIndex = Search.findInObjectStates(--[[---@not nil]] self.containedObjectsData(), search)
            if foundData then
                return wrapContainedObject(--[[---@not nil]] foundData, foundIndex)
            end
            return nil
        end

        ---@return seb_WrappedObject[]
        function self.getObjects()
            if self.containedObjectsData() then
                return TableUtil.map(--[[---@not nil]] self.containedObjectsData(), wrapContainedObject)
            end
            return {}
        end

        return self
    end
}))

return WrappedContainer