local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Slider : seb_XmlUi_Element

---@class seb_XmlUi_Slider_Static
---@overload fun(element: tts__UISliderElement): seb_XmlUi_Slider
local XmlUiSlider = {}

local Attributes = {}

setmetatable(XmlUiSlider, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UISliderElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Slider]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Slider", XmlUiSlider, Attributes)

return XmlUiSlider
