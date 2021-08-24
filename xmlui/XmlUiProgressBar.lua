local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_ProgressBar : seb_XmlUi_Element

---@class seb_XmlUi_ProgressBar_Static
---@overload fun(element: tts__UIProgressBarElement): seb_XmlUi_ProgressBar
local XmlUiProgressBar = {}

local Attributes = {}

setmetatable(XmlUiProgressBar, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIProgressBarElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_ProgressBar]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("ProgressBar", XmlUiProgressBar, Attributes)

return XmlUiProgressBar
