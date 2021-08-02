local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Option : seb_XmlUi_Element

---@class seb_XmlUi_Option_Static
---@overload fun(element: tts__UIOptionElement): seb_XmlUi_Option
local XmlUiOption = {}

---@shape seb_XmlUi_OptionAttributes : seb_XmlUi_Attributes
---@field value number | string
---@field selected nil | boolean
---@field [any] nil @All other fields are invalid

local OptionAttributes = {
    selected = XmlUiFactory.AttributeType.boolean,
}

setmetatable(XmlUiOption, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIOptionElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Option]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Option", XmlUiOption, OptionAttributes)
