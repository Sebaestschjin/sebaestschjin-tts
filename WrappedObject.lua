local Object = require("sebaestschjin-tts.Object")
local ObjectState = require("sebaestschjin-tts.ObjectState")
local TableUtil = require("sebaestschjin-tts.TableUtil")

local WrappedDecal = require("sebaestschjin-tts.WrappedDecal")

---@class seb_WrappedObject

---@class seb_WrappedObject_static : seb_WrappedObject
---@overload fun(data: tts__ObjectState): seb_WrappedObject
---@overload fun(data: tts__ObjectState, index: number): seb_WrappedObject
local WrappedObject = {}

setmetatable(WrappedObject, {
    __call = function(_, data, index)
        local self = --[[---@type seb_WrappedObject]] {}

        ---@type tts__ObjectState
        local internal = data

        ---@type tts__ObjectType
        self.type = Object.TypeForName[internal.Name]
        ---@type number
        self.index = index

        ---@return GUID
        function self.getGUID()
            return --[[---@not nil]] internal.GUID
        end

        ---@return string
        function self.getName()
            return --[[---@not nil]] internal.Nickname
        end

        ---@return string
        function self.getDescription()
            return --[[---@not nil]] internal.Description
        end

        ---@return tts__Vector
        function self.getPosition()
            return ObjectState.transformToPosition(--[[---@not nil]] internal.Transform)
        end

        ---@return tts__ObjectState
        function self.getData()
            return internal
        end

        ---@return seb_WrappedDecal[]
        function self.getDecals()
            if internal.AttachedDecals then
                return TableUtil.map(--[[---@not nil]] internal.AttachedDecals, function(decalData)
                    return WrappedDecal(decalData)
                end)
            end
            return {}
        end

        return self
    end
})

return WrappedObject