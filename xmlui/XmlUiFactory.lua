local Logger = require("sebaestschjin-tts.Logger")
local Math = require("sebaestschjin-tts.Math")
local TableUtil = require("sebaestschjin-tts.TableUtil")

local XmlUiFactory = {}

---@alias seb_XmlUi_FactoryMethod fun(element: tts__UIElement): seb_XmlUi_Element

---@shape seb_XmlUi_Factory
---@field Attributes table<string, seb_XmlUi_AttributeType>
---@field Method seb_XmlUi_FactoryMethod

---@type table<string, seb_XmlUi_Factory>
local ElementFactory = {}
local DefaultFactoryName = "__default__"

---@alias seb_XmlUi_AttributeType 'boolean' | 'string' | 'integer' | 'float' | 'floats' | 'handler' | 'color' | 'colorBlock' | 'padding' | 'players' | 'vector2' | 'vector4'

XmlUiFactory.AttributeType = {
    boolean = "boolean",
    string = "string",
    integer = "integer",
    float = "float",
    floats = "floats",
    handler = "handler",
    color = "color",
    colorBlock = "colorBlock",
    padding = "padding",
    players = "players",
    vector2 = "vector2",
    vector4 = "vector4",
}

---@overload fun(value: tts__UIAttributeValue, separator: string): string
---@param value tts__UIAttributeValue
---@param separator string
---@param multiple number
---@return string
local function toConcatenatedString(value, separator, multiple)
    multiple = multiple or 1

    local values = --[[---@type tts__UIAttributeValue]] {}
    if type(value) ~= "table" then
        for _ = 1, multiple do
            table.insert(values, value)
        end
    else
        values = value
    end

    return table.concat(--[[---@type string[] ]] values, separator)
end

---@return nil | string
local function toList(value)
    return toConcatenatedString(value, " ")
end

---@param value seb_XmlUi_Color
---@return string
local function toColor(value)
    if type(value) == "string" then
        return --[[---@type string]] value
    end

    ---@type tts__NumColorShape
    local numColor
    if (--[[---@type tts__CharColorShape]] value).r ~= nil then
        local charColor = --[[---@type tts__CharColorShape]] value
        numColor = { charColor.r, charColor.g, charColor.b, charColor.a }
    else
        numColor = --[[---@type tts__NumColorShape]] value
    end

    for i, v in ipairs(numColor) do
        if v > 1 then
            numColor[i] = Math.round(v / 255, 2)
        end
    end

    if numColor[4] ~= nil then
        return string.format("rgba(%s,%s,%s,%s)", numColor[1], numColor[2], numColor[3], numColor[4])
    else
        return string.format("rgb(%s,%s,%s)", numColor[1], numColor[2], numColor[3])
    end
end

---@param value seb_XmlUi_ColorBlock
---@return string
local function toColorBlock(value)
    return table.concat(TableUtil.map(value, toColor), "|")
end

---@param value seb_XmlUi_Padding
---@return string
local function toPadding(value)
    if type(value) == "number" then
        return toList({ value, value, value, value })
    end

    if value.l ~= nil then
        local charPadding = --[[---@type seb_XmlUi_Padding_Char]] value
        return toList({ charPadding.l, charPadding.r, charPadding.t, charPadding.b })
    end

    if value.h ~= nil then
        local charPadding = --[[---@type seb_XmlUi_Padding_AxisChar]] value
        return toList({ charPadding.h, charPadding.h, charPadding.v, charPadding.v })
    end

    return toList(value)
end

---@param value nil | seb_XmlUi_EventHandler
---@return string
local function toHandlerFunction(value)
    if type(value) == "table" then
        local asTable = --[[---@type seb_XmlUi_ObjectEventHandler]] value
        return asTable[1].getGUID() .. "/" .. asTable[2]
    end
    return --[[---@type string]] value
end

---@return string
local function toPlayerColors(value)
    return toConcatenatedString(value, "|")
end

---@param value tts__UIAttributeValue
---@return tts__UIAttributeValue
local function identity(value)
    return value
end

XmlUiFactory.Converter = {
    toColor = toColor,
}

---@type table<seb_XmlUi_AttributeType, fun(value: tts__UIAttributeValue): tts__UIAttributeValue>
local AttributeTypeMapper = {
    [XmlUiFactory.AttributeType.string] = identity,
    [XmlUiFactory.AttributeType.integer] = identity,
    [XmlUiFactory.AttributeType.float] = identity,
    [XmlUiFactory.AttributeType.floats] = toList,
    [XmlUiFactory.AttributeType.boolean] = identity,
    [XmlUiFactory.AttributeType.handler] = toHandlerFunction,
    [XmlUiFactory.AttributeType.color] = toColor,
    [XmlUiFactory.AttributeType.colorBlock] = toColorBlock,
    [XmlUiFactory.AttributeType.padding] = toPadding,
    [XmlUiFactory.AttributeType.players] = toPlayerColors,
    [XmlUiFactory.AttributeType.vector2] = toList,
    [XmlUiFactory.AttributeType.vector4] = toList,
}

---@param tag string
---@param constructor seb_XmlUi_FactoryMethod
---@param attributes table<string, seb_XmlUi_AttributeType>
function XmlUiFactory.register(tag, constructor, attributes)
    local factory = {
        Method = constructor,
        Attributes = attributes,
    }
    if tag then
        ElementFactory[tag] = factory
    else
        ElementFactory[DefaultFactoryName] = factory
    end
end

---@param element table
---@param attributes seb_XmlUi_Attributes
---@param name string
---@param mapper fun(value: any): any
local function copyAttribute(element, attributes, name, mapper)
    local value = attributes[name]
    if value ~= nil then
        if mapper then
            value = mapper(value)
        end
        (--[[---@not nil]] element.attributes)[name] = value
    end
end

---@param element table
---@param attributes seb_XmlUi_Attributes
---@param availableAttributes table<string, seb_XmlUi_AttributeType>
local function copyAttributes(element, attributes, availableAttributes)
    for attribute, attributeType in pairs(availableAttributes) do
        copyAttribute(element, attributes, attribute, AttributeTypeMapper[attributeType])
    end
end

---@param element tts__UIElement
---@return seb_XmlUi_Element
function XmlUiFactory.wrapElement(element)
    local factory = ElementFactory[element.tag]
    if factory then
        return factory.Method(element)
    end

    Logger.verbose("No factory found for element of type %s. Using default one.", element.tag)
    return ElementFactory[DefaultFactoryName].Method(element)
    --uiElement.bindUi(self) -- TODO !!!
end

---@param tag tts__UIElement_Tag
---@param attributes nil | seb_XmlUi_Attributes
---@return seb_XmlUi_Element
function XmlUiFactory.createElement(tag, attributes)
    local theAttributes = attributes or {}
    ---@type tts__UIElement
    local ttsElement = {
        tag = tag,
        attributes = --[[---@type table<string, tts__UIAttributeValue>]] {},
        children = {}
    }
    copyAttributes(ttsElement, theAttributes, ElementFactory[DefaultFactoryName].Attributes)
    copyAttributes(ttsElement, theAttributes, ElementFactory[tag].Attributes)

    if theAttributes.value then
        ttsElement.value = theAttributes.value
    end

    for name, value in pairs(theAttributes) do
        if name ~= "value" and value ~= nil and ttsElement.attributes[name] == nil then
            Logger.warn("Unmapped attribute '%s'!", name)
        end
    end

    return ElementFactory[tag].Method(ttsElement)
end

---@param attributes seb_XmlUi_ButtonAttributes
---@return seb_XmlUi_Button
function XmlUiFactory.createButton(attributes)
    return --[[---@type seb_XmlUi_Button]] XmlUiFactory.createElement("Button", attributes)
end

---@overload fun(): seb_XmlUi_Cell
---@param attributes seb_XmlUi_CellAttributes
---@return seb_XmlUi_Cell
function XmlUiFactory.createCell(attributes)
    return --[[---@type seb_XmlUi_Cell]] XmlUiFactory.createElement("Cell", attributes)
end

---@param attributes seb_XmlUi_DropdownAttributes
---@return seb_XmlUi_Dropdown
function XmlUiFactory.createDropdown(attributes)
    return --[[---@type seb_XmlUi_Dropdown]] XmlUiFactory.createElement("Dropdown", attributes)
end

---@param attributes seb_XmlUi_GridLayoutAttributes
---@return seb_XmlUi_GridLayout
function XmlUiFactory.createGridLayout(attributes)
    return --[[---@type seb_XmlUi_GridLayout]] XmlUiFactory.createElement("GridLayout", attributes)
end

---@param attributes seb_XmlUi_AxisLayoutAttributes
---@return seb_XmlUi_AxisLayout
function XmlUiFactory.createHorizontalLayout(attributes)
    return --[[---@type seb_XmlUi_AxisLayout]] XmlUiFactory.createElement("HorizontalLayout", attributes)
end

---@overload fun(): seb_XmlUi_ScrollView
---@param attributes seb_XmlUi_ScrollViewAttributes
---@return seb_XmlUi_ScrollView
function XmlUiFactory.createHorizontalScrollView(attributes)
    return --[[---@type seb_XmlUi_ScrollView]] XmlUiFactory.createElement("HorizontalScrollView", attributes)
end

---@param attributes seb_XmlUi_ImageAttributes
---@return seb_XmlUi_Image
function XmlUiFactory.createImage(attributes)
    return --[[---@type seb_XmlUi_Image]] XmlUiFactory.createElement("Image", attributes)
end

---@param attributes seb_XmlUi_OptionAttributes
---@return seb_XmlUi_Option
function XmlUiFactory.createOption(attributes)
    return --[[---@type seb_XmlUi_Option]] XmlUiFactory.createElement("Option", attributes)
end

---@param attributes seb_XmlUi_PanelAttributes
---@return seb_XmlUi_Panel
function XmlUiFactory.createPanel(attributes)
    return --[[---@type seb_XmlUi_Panel]] XmlUiFactory.createElement("Panel", attributes)
end

---@overload fun(): seb_XmlUi_Row
---@param attributes seb_XmlUi_RowAttributes
---@return seb_XmlUi_Row
function XmlUiFactory.createRow(attributes)
    return --[[---@type seb_XmlUi_Row]] XmlUiFactory.createElement("Row", attributes)
end

---@param attributes seb_XmlUi_TableLayoutAttributes
---@return seb_XmlUi_TableLayout
function XmlUiFactory.createTableLayout(attributes)
    return --[[---@type seb_XmlUi_TableLayout]] XmlUiFactory.createElement("TableLayout", attributes)
end

---@param attributes seb_XmlUi_TextAttributes
---@return seb_XmlUi_Text
function XmlUiFactory.createText(attributes)
    return --[[---@type seb_XmlUi_Text]] XmlUiFactory.createElement("Text", attributes)
end

---@param attributes seb_XmlUi_ToggleAttributes
---@return seb_XmlUi_Toggle
function XmlUiFactory.createToggle(attributes)
    return --[[---@type seb_XmlUi_Toggle]] XmlUiFactory.createElement("Toggle", attributes)
end

---@param attributes seb_XmlUi_AxisLayoutAttributes
---@return seb_XmlUi_AxisLayout
function XmlUiFactory.createVerticalLayout(attributes)
    return --[[---@type seb_XmlUi_AxisLayout]] XmlUiFactory.createElement("VerticalLayout", attributes)
end

---@overload fun(): seb_XmlUi_ScrollView
---@param attributes seb_XmlUi_ScrollViewAttributes
---@return seb_XmlUi_ScrollView
function XmlUiFactory.createVerticalScrollView(attributes)
    return --[[---@type seb_XmlUi_ScrollView]] XmlUiFactory.createElement("VerticalScrollView", attributes)
end

return XmlUiFactory

