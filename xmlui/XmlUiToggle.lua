local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")

---@class seb_XmlUi_Toggle : seb_XmlUi_Element

---@class seb_XmlUi_Toggle_Static
---@overload fun(element: tts__UIToggleElement): seb_XmlUi_Toggle
local XmlUiToggle = {}

---@shape seb_XmlUi_ToggleAttributes : seb_XmlUi_Attributes
---@field onValueChanged nil | seb_XmlUi_EventHandler
---@field isOn nil | boolean
---@field [any] nil @All other fields are invalid

local Attributes = {
    isOn = XmlUiFactory.AttributeType.boolean,
    onValueChanged = XmlUiFactory.AttributeType.handler,
}

setmetatable(XmlUiToggle, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIToggleElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Toggle]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Toggle", XmlUiToggle, Attributes)

return XmlUiToggle
