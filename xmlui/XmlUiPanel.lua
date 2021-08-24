local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Panel : seb_XmlUi_Element

---@class seb_XmlUi_Panel_Static
---@overload fun(element: tts__UIPanelElement): seb_XmlUi_Panel
local XmlUiPanel = {}

---@shape seb_XmlUi_PanelAttributes : seb_XmlUi_Attributes
---@field [any] nil @All other fields are invalid

local Attributes = {}

setmetatable(XmlUiPanel, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIPanelElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Panel]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Panel", XmlUiPanel, Attributes)

return XmlUiPanel
