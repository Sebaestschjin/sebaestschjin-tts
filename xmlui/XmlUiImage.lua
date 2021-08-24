local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Image : seb_XmlUi_Element

---@class seb_XmlUi_Image_Static
---@overload fun(element: tts__UIImageElement): seb_XmlUi_Image
local XmlUiImage = {}

---@shape seb_XmlUi_ImageAttributes : seb_XmlUi_Attributes
---@field image URL
---@field preserveAspect nil | boolean
---@field [any] nil @All other fields are invalid

local Attributes = {
    image = XmlUiFactory.AttributeType.string,
    preserveAspect = XmlUiFactory.AttributeType.boolean,
}

setmetatable(XmlUiImage, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIImageElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Image]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Image", XmlUiImage, Attributes)

return XmlUiImage
