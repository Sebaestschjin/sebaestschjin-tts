local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_InputField : seb_XmlUi_Element

---@class seb_XmlUi_InputField_Static
---@overload fun(element: tts__UIInputFieldElement): seb_XmlUi_InputField
local XmlUiInputField = {}

---@shape seb_XmlUi_InputFieldAttributes : seb_XmlUi_Attributes
---@field text nil | string
---@field placeholder nil | string
---@field textAlignment nil | tts__UIElement_Alignment
---@field characterValidation nil | "None" | "Integer" | "Decimal" | "Alphanumeric" | "Name" | "EmailAddress"
---@field colors nil | seb_XmlUi_ColorBlock
---@field onEndEdit nil | seb_XmlUi_EventHandler
---@field onValueChanged nil | seb_XmlUi_EventHandler
---@field [any] nil @All other fields are invalid

local Attributes = {
  text = XmlUiFactory.AttributeType.string,
  placeholder = XmlUiFactory.AttributeType.string,
  characterValidation = XmlUiFactory.AttributeType.string,
  textAlignment = XmlUiFactory.AttributeType.string,
  colors = XmlUiFactory.AttributeType.colorBlock,
  onEndEdit = XmlUiFactory.AttributeType.handler,
  onValueChanged = XmlUiFactory.AttributeType.handler,
}

setmetatable(XmlUiInputField, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIInputFieldElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_InputField]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("InputField", XmlUiInputField, Attributes)

return XmlUiInputField
