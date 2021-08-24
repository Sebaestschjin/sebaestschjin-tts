local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Dropdown : seb_XmlUi_Element

---@class seb_XmlUi_DropDown_Static
---@overload fun(element: tts__UIDropdownElement): seb_XmlUi_Dropdown
local XmlUiDropdown = {}

---@shape seb_XmlUi_DropdownAttributes : seb_XmlUi_Attributes
---@field arrowColor nil | seb_XmlUi_Color
---@field arrowImage nil | tts__UIAssetName
---@field checkColor nil | seb_XmlUi_Color
---@field checkImage nil | tts__UIAssetName
---@field dropdownBackgroundColor nil | seb_XmlUi_Color
---@field dropdownBackgroundImage nil | tts__UIAssetName
---@field image nil | tts__UIAssetName @The image used as the background for a closed dropdown.
---@field itemBackgroundColors nil | seb_XmlUi_ColorBlock
---@field itemHeight nil | number
---@field itemTextColor nil | seb_XmlUi_Color
---@field onValueChanged nil | seb_XmlUi_EventHandler
---@field scrollbarColors nil | seb_XmlUi_ColorBlock
---@field scrollbarImage nil | tts__UIAssetName
---@field textColor nil | seb_XmlUi_Color
---@field [any] nil @All other fields are invalid

local Attributes = {
    arrowColor = XmlUiFactory.AttributeType.color,
    arrowImage = XmlUiFactory.AttributeType.string,
    checkColor = XmlUiFactory.AttributeType.color,
    checkImage = XmlUiFactory.AttributeType.string,
    dropdownBackgroundColor = XmlUiFactory.AttributeType.color,
    dropdownBackgroundImage = XmlUiFactory.AttributeType.string,
    image = XmlUiFactory.AttributeType.string,
    itemBackgroundColors = XmlUiFactory.AttributeType.colorBlock,
    itemHeight = XmlUiFactory.AttributeType.integer,
    itemTextColor = XmlUiFactory.AttributeType.color,
    onValueChanged = XmlUiFactory.AttributeType.handler,
    scrollbarColors = XmlUiFactory.AttributeType.color,
    scrollbarImage = XmlUiFactory.AttributeType.string,
    textColor = XmlUiFactory.AttributeType.color,
}

setmetatable(XmlUiDropdown, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIDropdownElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Dropdown]] XmlUiElement(element)

        ---@param attributes seb_XmlUi_OptionAttributes
        function self.addOption(attributes)
            local option = XmlUiFactory.createOption(attributes)
            self.addChild(option)
            return option
        end

        return self
    end
}))

XmlUiFactory.register("Dropdown", XmlUiDropdown, Attributes)

return XmlUiDropdown
