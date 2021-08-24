local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Defaults : seb_XmlUi_Element

---@class seb_XmlUi_Defaults_Static
---@overload fun(element: tts__UIDefaultsElement): seb_XmlUi_Defaults
local XmlUiDefaults = {}

local Attributes = {}

setmetatable(XmlUiDefaults, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIDefaultsElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Defaults]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Defaults", XmlUiDefaults, Attributes)

return XmlUiDefaults
