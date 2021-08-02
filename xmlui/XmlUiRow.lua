local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Row : seb_XmlUi_Element

---@class seb_XmlUi_Row_Static
---@overload fun(element: tts__UIRowElement): seb_XmlUi_Row
local XmlUiRow = {}

---@shape seb_XmlUi_RowAttributes : seb_XmlUi_Attributes
---@field dontUseTableRowBackground nil | boolean
---@field image nil | tts__UIAssetName
---@field [any] nil @All other fields are invalid

local RowAttributes = {
    dontUseTableRowBackground = XmlUiFactory.AttributeType.boolean,
    image = XmlUiFactory.AttributeType.string,
}

setmetatable(XmlUiRow, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIRowElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Row]] XmlUiElement(element)

        local super_addChild = self.addChild

        ---@overload fun(): seb_XmlUi_Cell
        ---@param attributes seb_XmlUi_CellAttributes
        ---@return seb_XmlUi_Cell
        function self.addCell(attributes)
            local cell = XmlUiFactory.createCell(attributes)
            self.addChild(cell)
            return cell
        end

        ---@param uiElement seb_XmlUi_Element
        function self.addChild(uiElement)
            if uiElement.getType() ~= "Cell" then
                local cell = XmlUiFactory.createCell()
                cell.addChild(uiElement)
                super_addChild(cell)
            else
                super_addChild(uiElement)
            end
        end

        return self
    end
}))

XmlUiFactory.register("Row", XmlUiRow, RowAttributes)