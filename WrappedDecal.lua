local ObjectState = require("sebaestschjin-tts.ObjectState")

---@class seb_WrappedDecal

---@class seb_WrappedDecal_static : seb_WrappedDecal
---@overload fun(data: tts__ObjectState_Decal): seb_WrappedDecal
local WrappedDecal = {}

setmetatable(WrappedDecal, {
    __call = function(_, data)
        local self = --[[---@type seb_WrappedDecal]] {}

        ---@type string
        self.name = data.CustomDecal.Name
        ---@type URL
        self.url = data.CustomDecal.ImageURL
        ---@type tts__Vector
        self.position = ObjectState.transformToPosition(data.Transform)
        ---@type tts__Vector
        self.rotation = ObjectState.transformToRotation(data.Transform)
        ---@type tts__Vector
        self.scale = ObjectState.transformToScale(data.Transform)

        return self
    end
})

return WrappedDecal
