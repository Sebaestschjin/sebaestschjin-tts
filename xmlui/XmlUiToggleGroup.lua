local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_ToggleGroup : seb_XmlUi_Element

---@class seb_XmlUi_ToggleGroup_Static
---@overload fun(element: tts__UIToggleGroupElement): seb_XmlUi_ToggleGroup
local XmlUiToggleGroup = {}

local Attributes = {}

setmetatable(XmlUiToggleGroup, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIToggleGroupElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_ToggleGroup]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("ToggleGroup", XmlUiToggleGroup, Attributes)

return XmlUiToggleGroup
