local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Button : seb_XmlUi_Element

---@class seb_XmlUi_Button_Static
---@overload fun(element: tts__UIButtonElement): seb_XmlUi_Button
local XmlUiButton = {}

local Attributes = {
    colors = XmlUiFactory.AttributeType.colorBlock,
    textColor = XmlUiFactory.AttributeType.color,
}

---@shape seb_XmlUi_ButtonAttributes : seb_XmlUi_Attributes
---@field text nil | string
---@field value nil | string
---@field textColor nil | seb_XmlUi_Color
---@field colors nil | seb_XmlUi_ColorBlock
---@field [any] nil @All other fields are invalid

setmetatable(XmlUiButton, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIButtonElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Button]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Button", XmlUiButton, Attributes)

return XmlUiButton
