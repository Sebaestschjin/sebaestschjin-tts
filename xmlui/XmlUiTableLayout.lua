local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_TableLayout : seb_XmlUi_Element

---@class seb_XmlUi_TableLayout_Static
---@overload fun(element: tts__UITableLayoutElement): seb_XmlUi_TableLayout
local XmlUiTableLayout = {}

---@shape seb_XmlUi_TableLayoutAttributes : seb_XmlUi_Attributes
---@field columnWidths nil | number[]
---@field padding nil | seb_XmlUi_Padding
---@field rowBackgroundColor nil | seb_XmlUi_Color | 'clear'
---@field rowBackgroundImage nil | tts__UIAssetName
---@field cellBackgroundColor nil | seb_XmlUi_Color | 'clear'
---@field cellBackgroundImage nil | tts__UIAssetName
---@field cellPadding nil | seb_XmlUi_Padding
---@field autoCalculateHeight nil | boolean
---@field [any] nil @All other fields are invalid

local Attributes = {
    autoCalculateHeight = XmlUiFactory.AttributeType.boolean,
    cellBackgroundColor = XmlUiFactory.AttributeType.color,
    cellBackgroundImage = XmlUiFactory.AttributeType.string,
    cellPadding = XmlUiFactory.AttributeType.padding,
    columnWidths = XmlUiFactory.AttributeType.floats,
    padding = XmlUiFactory.AttributeType.padding,
    rowBackgroundColor = XmlUiFactory.AttributeType.color,
    rowBackgroundImage = XmlUiFactory.AttributeType.string,
}

setmetatable(XmlUiTableLayout, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UITableLayoutElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_TableLayout]] XmlUiElement(element)

        ---@overload fun(): seb_XmlUi_Row
        ---@param attributes seb_XmlUi_RowAttributes
        ---@return seb_XmlUi_Row
        function self.addRow(attributes)
            local row = XmlUiFactory.createRow(attributes)
            self.addChild(row)
            return row
        end

        return self
    end
}))

XmlUiFactory.register("TableLayout", XmlUiTableLayout, Attributes)

return XmlUiTableLayout
