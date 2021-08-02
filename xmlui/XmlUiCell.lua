local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")
local XmlUiElement = require("sebaestschjin-tts.xmlui.XmlUiElement")

---@class seb_XmlUi_Cell : seb_XmlUi_Element

---@class seb_XmlUi_Cell_Static
---@overload fun(element: tts__UICellElement): seb_XmlUi_Cell
local XmlUiCell = {}

---@shape seb_XmlUi_CellAttributes : seb_XmlUi_Attributes
---@field columnSpan nil | integer @Default 1
---@field dontUseTableCellBackground nil |  boolean @Default false
---@field image nil | string
---@field overrideGlobalCellPadding nil | boolean @Default false
---@field padding nil | seb_XmlUi_Padding
---@field [any] nil @All other fields are invalid

local CellAttributes = {
    columnSpan = XmlUiFactory.AttributeType.integer,
    dontUseTableCellBackground = XmlUiFactory.AttributeType.boolean,
    image = XmlUiFactory.AttributeType.string,
    overrideGlobalCellPadding = XmlUiFactory.AttributeType.boolean,
    padding = XmlUiFactory.AttributeType.padding,
}

setmetatable(XmlUiCell, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UICellElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Cell]] XmlUiElement(element)

        return self
    end
}))

XmlUiFactory.register("Cell", XmlUiCell, CellAttributes)