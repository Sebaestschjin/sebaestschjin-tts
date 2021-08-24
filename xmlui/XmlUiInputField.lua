local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_InputField : seb_XmlUi_Element

---@class seb_XmlUi_InputField_Static
---@overload fun(element: tts__UIInputFieldElement): seb_XmlUi_InputField
local XmlUiInputField = {}

local Attributes = {}

setmetatable(XmlUiInputField, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIInputFieldElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_InputField]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("InputField", XmlUiInputField, Attributes)

return XmlUiInputField
