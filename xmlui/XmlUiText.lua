local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Text : seb_XmlUi_Element

---@class seb_XmlUi_Text_Static
---@overload fun(element: tts__UITextElement): seb_XmlUi_Text
local XmlUiText = {}

---@shape seb_XmlUi_TextAttributes : seb_XmlUi_Attributes
---@field text nil | string
---@field value nil | string
---@field [any] nil @All other fields are invalid

local Attributes = {}

setmetatable(XmlUiText, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UITextElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Text]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Text", XmlUiText, Attributes)

return XmlUiText
