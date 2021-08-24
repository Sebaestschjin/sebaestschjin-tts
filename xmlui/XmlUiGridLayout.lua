local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_GridLayout : seb_XmlUi_Element

---@class seb_XmlUi_GridLayout_Static
---@overload fun(element: tts__UIGridLayoutElement): seb_XmlUi_GridLayout
local XmlUiGridLayout = {}

---@shape seb_XmlUi_GridLayoutAttributes : seb_XmlUi_Attributes
---@field padding nil | seb_XmlUi_Padding @Default {0, 0, 0, 0}
---@field spacing nil | seb_XmlUi_Size @Default {0, 0}
---@field cellSize nil | seb_XmlUi_Size @Default {100, 100}
---@field startCorner nil | tts__UIElement_Alignment_Corner @Default "UpperLeft"
---@field startAxis nil | tts__UIElement_Alignment_Axis @Default "Horizontal"
---@field childAlignment nil | tts__UIElement_Alignment @Default "UpperLeft"
---@field constraint nil | tts__UIGridLayoutElement_Constraint @Default "Flexible"
---@field constraintCount nil | number @Default 2
---@field [any] nil @All other fields are invalid


local Attributes = {
    cellSize = XmlUiFactory.AttributeType.vector2,
    constraint = XmlUiFactory.AttributeType.string,
    constraintCount = XmlUiFactory.AttributeType.integer,
    spacing = XmlUiFactory.AttributeType.vector2,
    startAxis = XmlUiFactory.AttributeType.string,
    startCorner = XmlUiFactory.AttributeType.string,
}

setmetatable(XmlUiGridLayout, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIGridLayoutElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_GridLayout]] XmlUiElement(element)

        ---@param value tts__UIGridLayoutElement_Constraint
        function self.setConstraint(value)
            self.setAttribute("constraint", value)
        end

        ---@param value number
        function self.setConstraintCount(value)
            self.setAttribute("constraintCount", value)
        end

        return self
    end
}))

XmlUiFactory.register("GridLayout", XmlUiGridLayout, Attributes)

return XmlUiGridLayout
