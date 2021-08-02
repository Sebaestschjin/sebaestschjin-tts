local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_ToggleButton : seb_XmlUi_Element

---@class seb_XmlUi_ToggleButton_Static
---@overload fun(element: tts__UIToggleButtonElement): seb_XmlUi_ToggleButton
local XmlUiToggleButton = {}

local Attributes = {}

setmetatable(XmlUiToggleButton, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIToggleButtonElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_ToggleButton]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("ToggleButton", XmlUiToggleButton, Attributes)

return XmlUiToggleButton
