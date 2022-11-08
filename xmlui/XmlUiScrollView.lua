local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_ScrollView : seb_XmlUi_Element

---@class seb_XmlUi_ScrollView_Static
---@overload fun(element: tts__UIScrollViewElement): seb_XmlUi_ScrollView
local XmlUiScrollView = {}

---@shape seb_XmlUi_ScrollViewAttributes : seb_XmlUi_Attributes
---@field scrollbarBackgroundColor nil | seb_XmlUi_Color
---@field scrollbarColors nil | seb_XmlUi_ColorBlock
---@field scrollSensitivity nil | number
---@field [any] nil @All other fields are invalid

local Attributes = {
  scrollbarBackgroundColor = XmlUiFactory.AttributeType.color,
  scrollbarColors = XmlUiFactory.AttributeType.colorBlock,
  scrollSensitivity = XmlUiFactory.AttributeType.float,
}

setmetatable(XmlUiScrollView, TableUtil.merge(getmetatable(XmlUiElement), {
  ---@param element tts__UIScrollViewElement
  __call = function(_, element)
    local self = --[[---@type seb_XmlUi_ScrollView]] XmlUiElement(element)

    return self
  end
}))

XmlUiFactory.register("HorizontalScrollView", XmlUiScrollView, Attributes)
XmlUiFactory.register("VerticalScrollView", XmlUiScrollView, Attributes)

return XmlUiScrollView
