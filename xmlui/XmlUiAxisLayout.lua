local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_AxisLayout : seb_XmlUi_Element

---@class seb_XmlUi_AxisLayout_Static
---@overload fun(element: tts__UIHorizontalLayoutElement | tts__UIVerticalLayoutElement): seb_XmlUi_AxisLayout
local XmlUiAxisLayout = {}

---@shape seb_XmlUi_AxisLayoutAttributes : seb_XmlUi_Attributes
---@field childAlignment nil | tts__UIElement_Alignment
---@field childForceExpandWidth nil | boolean
---@field childForceExpandHeight nil | boolean
---@field padding nil | seb_XmlUi_Padding
---@field spacing nil | integer
---@field [any] nil @All other fields are invalid

local Attributes = {
    childAlignment = XmlUiFactory.AttributeType.string,
    childForceExpandWidth = XmlUiFactory.AttributeType.boolean,
    childForceExpandHeight = XmlUiFactory.AttributeType.boolean,
    padding = XmlUiFactory.AttributeType.padding,
    spacing = XmlUiFactory.AttributeType.integer,
}

setmetatable(XmlUiAxisLayout, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIHorizontalLayoutElement | tts__UIVerticalLayoutElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_AxisLayout]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("HorizontalLayout", XmlUiAxisLayout, Attributes)
XmlUiFactory.register("VerticalLayout", XmlUiAxisLayout, Attributes)

return XmlUiAxisLayout
