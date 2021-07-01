local Logger = require("sebaestschjin-tts.Logger")
local Math = require("sebaestschjin-tts.Math")
local TableUtil = require("sebaestschjin-tts.TableUtil")

---@class seb_XmlUi_Container_Static
---@overload fun(): seb_XmlUi_Container
local XmlUiContainer = {}

---@class seb_XmlUi_Static
---@overload fun(object: tts__Object): seb_XmlUi
local XmlUi = {}

---@class seb_XmlUi_Element_Static
---@overload fun(element: tts__UIElement): seb_XmlUi_Element
local XmlUiElement = {}

---@class seb_XmlUi_Defaults_Static
---@overload fun(element: tts__UIDefaultsElement): seb_XmlUi_Defaults
local XmlUiDefaults = {}

---@class seb_XmlUi_Text_Static
---@overload fun(element: tts__UITextElement): seb_XmlUi_Text
local XmlUiText = {}

---@class seb_XmlUi_InputField_Static
---@overload fun(element: tts__UIInputFieldElement): seb_XmlUi_InputField
local XmlUiInputField = {}

---@class seb_XmlUi_Button_Static
---@overload fun(element: tts__UIButtonElement): seb_XmlUi_Button
local XmlUiButton = {}

---@class seb_XmlUi_Image_Static
---@overload fun(element: tts__UIImageElement): seb_XmlUi_Image
local XmlUiImage = {}

---@class seb_XmlUi_Toggle_Static
---@overload fun(element: tts__UIToggleElement): seb_XmlUi_Toggle
local XmlUiToggle = {}

---@class seb_XmlUi_ToggleButton_Static
---@overload fun(element: tts__UIToggleButtonElement): seb_XmlUi_ToggleButton
local XmlUiToggleButton = {}

---@class seb_XmlUi_ToggleGroup_Static
---@overload fun(element: tts__UIToggleGroupElement): seb_XmlUi_ToggleGroup
local XmlUiToggleGroup = {}

---@class seb_XmlUi_DropDown_Static
---@overload fun(element: tts__UIDropdownElement): seb_XmlUi_Dropdown
local XmlUiDropdown = {}

---@class seb_XmlUi_Option_Static
---@overload fun(element: tts__UIOptionElement): seb_XmlUi_Option
local XmlUiOption = {}

---@class seb_XmlUi_ProgressBar_Static
---@overload fun(element: tts__UIProgressBarElement): seb_XmlUi_ProgressBar
local XmlUiProgressBar = {}

---@class seb_XmlUi_Slider_Static
---@overload fun(element: tts__UISliderElement): seb_XmlUi_Slider
local XmlUiSlider = {}

---@class seb_XmlUi_Panel_Static
---@overload fun(element: tts__UIPanelElement): seb_XmlUi_Panel
local XmlUiPanel = {}

---@class seb_XmlUi_AxisLayout_Static
---@overload fun(element: tts__UIHorizontalLayoutElement | tts__UIVerticalLayoutElement): seb_XmlUi_AxisLayout
local XmlUiAxisLayout = {}

---@class seb_XmlUi_GridLayout_Static
---@overload fun(element: tts__UIGridLayoutElement): seb_XmlUi_GridLayout
local XmlUiGridLayout = {}

---@class seb_XmlUi_TableLayout_Static
---@overload fun(element: tts__UITableLayoutElement): seb_XmlUi_TableLayout
local XmlUiTableLayout = {}

---@class seb_XmlUi_Row_Static
---@overload fun(element: tts__UIRowElement): seb_XmlUi_Row
local XmlUiRow = {}

---@class seb_XmlUi_Cell_Static
---@overload fun(element: tts__UICellElement): seb_XmlUi_Cell
local XmlUiCell = {}

---@class seb_XmlUi_ScrollView_Static
---@overload fun(element: tts__UIScrollViewElement): seb_XmlUi_ScrollView
local XmlUiScrollView = {}

XmlUi.Alignment = {
    UpperLeft = "UpperLeft",
    UpperCenter = "UpperCenter",
    UpperRight = "UpperRight",
    MiddleLeft = "MiddleLeft",
    MiddleCenter = "MiddleCenter",
    MiddleRight = "MiddleRight",
    LowerLeft = "LowerLeft",
    LowerCenter = "LowerCenter",
    LowerRight = "LowerRight",
}

--- Parameters available for animation attributes
XmlUi.Animation = {
    Show = {
        None = "None",
        Grow = "Grow",
        FadeIn = "FadeIn",
        SlideInLeft = "SlideIn_Left",
        SlideInRight = "SlideIn_Right",
        SlideInTop = "SlideIn_Top",
        SlideInBottom = "SlideIn_Bottom",
    },
    Hide = {
        None = "None",
        Shrink = "Shrink",
        FadeOut = "FadeOut",
        SlideOut_Left = "SlideOut_Left",
        SlideOutRight = "SlideOutRight",
        SlideOutTop = "SlideOut_Top",
        SlideOutBottom = "SlideOutBottom",
    },
}

XmlUi.FontStyle = {
    Bold = "Bold",
    BoldAndItalic = "BoldAndItalic",
    Italic = "Italic",
    Normal = "Normal",
}

XmlUi.GridLayout = {
    FixedColumnCount = "FixedColumnCount"
}

---@alias seb_XmlUi_FactoryMethod fun(element: tts__UIElement): seb_XmlUi_Element
---@shape seb_XmlUi_Factory
---@field [tts__UIElement_Tag] seb_XmlUi_FactoryMethod

local ElementFactory = {
    Defaults = XmlUiDefaults,
    Text = XmlUiText,
    InputField = XmlUiInputField,
    Button = XmlUiButton,
    Image = XmlUiImage,
    Toggle = XmlUiPanel,
    ToggleButton = XmlUiToggle,
    ToggleGroup = XmlUiToggleGroup,
    Dropdown = XmlUiDropdown,
    Option = XmlUiOption,
    Slider = XmlUiSlider,
    ProgressBar = XmlUiProgressBar,
    Panel = XmlUiPanel,
    HorizontalLayout = XmlUiAxisLayout,
    VerticalLayout = XmlUiAxisLayout,
    GridLayout = XmlUiGridLayout,
    TableLayout = XmlUiTableLayout,
    Row = XmlUiRow,
    Cell = XmlUiCell,
    HorizontalScrollView = XmlUiScrollView,
    VerticalScrollView = XmlUiScrollView,
}

---@overload fun(value: any, separator: string): string
---@param value any
---@param separator string
---@param multiple number
---@return nil | string
local function toConcatenatedString(value, separator, multiple)
    if not value then
        return nil
    end
    multiple = multiple or 1

    local values = {}
    if type(value) ~= "table" then
        for _ = 1, multiple do
            table.insert(values, value)
        end
    else
        values = value
    end

    return table.concat(--[[---@type string[] ]] values, separator)
end

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

local function toPlayerColors(value)
    return toConcatenatedString(value, "|")
end

local function identity(value)
    return value
end

local AttributeType = {
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

---@type table<string, fun(value: any): any>
local AttributeTypeMapper = {
    [AttributeType.string] = identity,
    [AttributeType.integer] = identity,
    [AttributeType.float] = identity,
    [AttributeType.floats] = toList,
    [AttributeType.boolean] = identity,
    [AttributeType.handler] = toHandlerFunction,
    [AttributeType.color] = toColor,
    [AttributeType.colorBlock] = toColorBlock,
    [AttributeType.padding] = toPadding,
    [AttributeType.players] = toPlayerColors,
    [AttributeType.vector2] = toList,
    [AttributeType.vector4] = toList,
}

local Attributes = {
    Basic = {
        -- General
        id = AttributeType.string,
        class = AttributeType.string,
        active = AttributeType.boolean,
        visibility = AttributeType.players,
        -- Text
        text = AttributeType.string,
        alignment = AttributeType.string,
        color = AttributeType.color,
        fontStyle = AttributeType.string,
        fontSize = AttributeType.integer,
        resizeTextForBestFit = AttributeType.boolean,
        resizeTextMinSize = AttributeType.integer,
        resizeTextMaxSize = AttributeType.integer,
        horizontalOverflow = AttributeType.string,
        verticalOverflow = AttributeType.string,
        -- Appearance
        shadow = AttributeType.color,
        shadowDistance = AttributeType.vector2,
        outline = AttributeType.color,
        outlineSize = AttributeType.vector2,
        -- Layout
        ignoreLayout = AttributeType.boolean,
        minWidth = AttributeType.integer,
        minHeight = AttributeType.integer,
        preferredWidth = AttributeType.integer,
        preferredHeight = AttributeType.integer,
        flexibleWidth = AttributeType.integer,
        flexibleHeight = AttributeType.integer,
        -- Position/Size
        rectAlignment = AttributeType.string,
        width = AttributeType.integer,
        height = AttributeType.integer,
        offsetXY = AttributeType.vector2,
        -- Dragging
        allowDragging = AttributeType.boolean,
        restrictDraggingToParentBounds = AttributeType.boolean,
        returnToOriginalPositionWhenReleased = AttributeType.boolean,
        -- Animation
        showAnimation = AttributeType.string,
        hideAnimation = AttributeType.string,
        showAnimationDelay = AttributeType.float,
        hideAnimationDelay = AttributeType.float,
        animationDuration = AttributeType.float,
        -- Tooltip
        tooltip = AttributeType.string,
        tooltipBackgroundColor = AttributeType.color,
        tooltipBackgroundImage = AttributeType.string,
        tooltipBorderColor = AttributeType.color,
        tooltipBorderImage = AttributeType.string,
        tooltipOffset = AttributeType.integer,
        tooltipPosition = AttributeType.string,
        tooltipTextColor = AttributeType.color,
        -- Event
        onClick = AttributeType.handler,
        onMouseEnter = AttributeType.handler,
        onMouseExit = AttributeType.handler,
        onMouseDown = AttributeType.handler,
        onMouseUp = AttributeType.handler,
    },
    Button = {
        textColor = AttributeType.color,
        colors = AttributeType.colorBlock,
    },
    Cell = {
        columnSpan = AttributeType.integer,
        dontUseTableCellBackground = AttributeType.boolean,
        image = AttributeType.string,
        overrideGlobalCellPadding = AttributeType.boolean,
        padding = AttributeType.padding,
    },
    Dropdown = {
        arrowColor = AttributeType.color,
        arrowImage = AttributeType.string,
        checkColor = AttributeType.color,
        checkImage = AttributeType.string,
        dropdownBackgroundColor = AttributeType.color,
        dropdownBackgroundImage = AttributeType.string,
        itemBackgroundColors = AttributeType.colorBlock,
        itemHeight = AttributeType.integer,
        itemTextColor = AttributeType.color,
        onValueChanged = AttributeType.handler,
        scrollbarColors = AttributeType.color,
        scrollbarImage = AttributeType.string,
        textColor = AttributeType.color,
    },
    GridLayout = {
        constraint = AttributeType.string,
        constraintCount = AttributeType.integer,
    },
    HorizontalLayout = {
        childAlignment = AttributeType.string,
        childForceExpandWidth = AttributeType.boolean,
        childForceExpandHeight = AttributeType.boolean,
        padding = AttributeType.padding,
        spacing = AttributeType.integer,
    },
    HorizontalScrollView = {
        scrollbarBackgroundColor = AttributeType.color,
        scrollbarColors = AttributeType.colorBlock,
    },
    Image = {
        image = AttributeType.string,
        preserveAspect = AttributeType.boolean,
    },
    Toggle = {
        isOn = AttributeType.boolean,
        onValueChanged = AttributeType.handler,
    },
    Option = {
        selected = AttributeType.boolean,
    },
    Row = {
        dontUseTableRowBackground = AttributeType.boolean,
        image = AttributeType.string,
    },
    TableLayout = {
        autoCalculateHeight = AttributeType.boolean,
        cellBackgroundColor = AttributeType.color,
        cellBackgroundImage = AttributeType.string,
        cellPadding = AttributeType.padding,
        columnWidths = AttributeType.floats,
        padding = AttributeType.padding,
        rowBackgroundColor = AttributeType.color,
        rowBackgroundImage = AttributeType.string,
    },
    VerticalLayout = {
        childAlignment = AttributeType.string,
        childForceExpandWidth = AttributeType.boolean,
        childForceExpandHeight = AttributeType.boolean,
        padding = AttributeType.padding,
        spacing = AttributeType.integer,
    },
    VerticalScrollView = {
        scrollbarBackgroundColor = AttributeType.color,
        scrollbarColors = AttributeType.colorBlock,
    },
}

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
---@param availableAttributes table<string, string>
local function copyAttributes(element, attributes, availableAttributes)
    for attribute, attributeType in pairs(availableAttributes) do
        copyAttribute(element, attributes, attribute, AttributeTypeMapper[attributeType])
    end
end

setmetatable(XmlUiContainer, {
    __call = function(_)
        local self = --[[---@type seb_XmlUi_Container]] {}

        ---@param unwrappedElements nil | tts__UIElement[]
        ---@return seb_XmlUi_Element[]
        function self._wrapChildren(unwrappedElements)
            local elements = --[[---@type seb_XmlUi_Element[] ]] {}
            for _, element in TableUtil.ipairs(unwrappedElements) do
                local factory = --[[---@type seb_XmlUi_FactoryMethod]] ElementFactory[element.tag]
                ---@type seb_XmlUi_Element
                local uiElement
                if factory then
                    uiElement = factory(element)
                else
                    uiElement = XmlUiElement(element)
                    Logger.verbose("No factory found for element of type %s. Using default one.", element.tag)
                end
                --uiElement.bindUi(self) -- TODO !!!
                table.insert(elements, uiElement)
            end
            return elements
        end

        ---@param _ seb_XmlUi_Element
        function self.addChild(_)
            Logger.error("Not implemented exception!")
        end

        ---@param _ number
        ---@return seb_XmlUi_Element
        function self.getChild(_)
            Logger.error("Not implemented exception!")
            return --[[---@type seb_XmlUi_Element]] nil
        end

        function self.clearElements()
            Logger.error("Not implemented exception!")
        end

        ---@generic E: seb_XmlUi_Element
        ---@param element E
        ---@return E
        local function addToChildren(element)
            self.addChild(element)
            return element
        end

        ---@overload fun(): seb_XmlUi_Text
        ---@param attributes seb_XmlUi_TextAttributes
        ---@return seb_XmlUi_Text
        function self.addText(attributes)
            return addToChildren(XmlUi.createText(attributes))
        end

        ---@param attributes seb_XmlUi_ButtonAttributes
        ---@return seb_XmlUi_Button
        function self.addButton(attributes)
            return addToChildren(XmlUi.createButton(attributes))
        end

        ---@param attributes seb_XmlUi_ImageAttributes
        ---@return seb_XmlUi_Image
        function self.addImage(attributes)
            return addToChildren(XmlUi.createImage(attributes))
        end

        ---@param attributes seb_XmlUi_ToggleAttributes
        ---@return seb_XmlUi_Toggle
        function self.addToggle(attributes)
            return addToChildren(XmlUi.createToggle(attributes))
        end

        ---@param attributes seb_XmlUi_DropdownAttributes
        ---@return seb_XmlUi_Dropdown
        function self.addDropdown(attributes)
            return addToChildren(XmlUi.createDropdown(attributes))
        end

        ---@overload fun(): seb_XmlUi_Panel
        ---@param attributes seb_XmlUi_PanelAttributes
        ---@return seb_XmlUi_Panel
        function self.addPanel(attributes)
            return addToChildren(XmlUi.createPanel(attributes))
        end

        ---@overload fun(): seb_XmlUi_AxisLayout
        ---@param attributes seb_XmlUi_AxisLayoutAttributes
        ---@return seb_XmlUi_AxisLayout
        function self.addVerticalLayout(attributes)
            return addToChildren(XmlUi.createVerticalLayout(attributes))
        end

        ---@overload fun(): seb_XmlUi_AxisLayout
        ---@param attributes seb_XmlUi_AxisLayoutAttributes
        ---@return seb_XmlUi_AxisLayout
        function self.addHorizontalLayout(attributes)
            return addToChildren(XmlUi.createHorizontalLayout(attributes))
        end

        ---@param attributes seb_XmlUi_TableLayoutAttributes
        ---@return seb_XmlUi_TableLayout
        function self.addTableLayout(attributes)
            return addToChildren(XmlUi.createTableLayout(attributes))
        end

        ---@param attributes seb_XmlUi_GridLayoutAttributes
        ---@return seb_XmlUi_GridLayout
        function self.addGridLayout(attributes)
            return addToChildren(XmlUi.createGridLayout(attributes))
        end

        ---@param attributes seb_XmlUi_ScrollViewAttributes
        ---@return seb_XmlUi_ScrollView
        function self.addHorizontalScrollView(attributes)
            return addToChildren(XmlUi.createHorizontalScrollView(attributes))
        end

        ---@param attributes seb_XmlUi_ScrollViewAttributes
        ---@return seb_XmlUi_ScrollView
        function self.addVerticalScrollView(attributes)
            return addToChildren(XmlUi.createVerticalScrollView(attributes))
        end

        return self
    end
})

setmetatable(XmlUi, TableUtil.merge(getmetatable(XmlUiContainer), {
    ---@param object tts__Object
    __call = function(_, object)
        local self = --[[---@type seb_XmlUi]] XmlUiContainer()
        local boundObject = object
        local children = self._wrapChildren(boundObject.UI.getXmlTable())
        local assets = boundObject.UI.getCustomAssets()

        ---@return tts__UIElement[]
        local function createXmlTable()
            return TableUtil.map(children, function(child) return child.getXmlElement() end)
        end

        ---@param elementId tts__UIElement_Id
        ---@return nil | seb_XmlUi_Element
        function self.findElement(elementId)
            -- TODO child elements
            for _, element in pairs(children) do
                if element.getId() == elementId then
                    return element
                end
            end
            return nil
        end

        ---@param elementId string
        ---@param attribute string
        ---@param value string | number | boolean
        function self.setAttribute(elementId, attribute, value)
            boundObject.UI.setAttribute(elementId, attribute, value)
        end

        ---@param element seb_XmlUi_Element
        function self.addChild(element)
            element.bindUi(self) -- TODO propagate to children
            table.insert(children, element)
        end

        ---@param elementId tts__UIElement_Id
        function self.show(elementId)
            boundObject.UI.show(elementId)
        end

        ---@param elementId tts__UIElement_Id
        function self.hide(elementId)
            boundObject.UI.hide(elementId)
        end

        function self.update()
            local xmlTable = createXmlTable()
            boundObject.UI.setCustomAssets(assets)
            boundObject.UI.setXmlTable(xmlTable)
        end

        ---@param assetName string
        ---@param assetUrl URL
        function self.updateAsset(assetName, assetUrl)
            for _, asset in ipairs(assets) do
                if asset.name == assetName then
                    asset.url = assetUrl
                    return
                end
            end

            table.insert(assets, { name = assetName, url = assetUrl, })
        end

        ---@param assetName string
        ---@return boolean
        function self.hasAsset(assetName)
            for _, asset in ipairs(assets) do
                if asset.name == assetName then
                    return true
                end
            end
            return false
        end

        return self
    end
}))

setmetatable(XmlUiElement, TableUtil.merge(getmetatable(XmlUiContainer), {
    ---@param element tts__UIElement
    __call = function(_, element)
        local self = --[[---@type seb_XmlUi_Element]] XmlUiContainer()
        local boundElement = element
        ---@type nil | seb_XmlUi
        local boundUi

        local children = self._wrapChildren(--[[---@type tts__UIElement[] ]] element.children)

        ---@param name string
        ---@return nil | string | number | boolean
        local function getAttribute(name)
            if boundElement.attributes then
                return (--[[---@type table<string, nil | string | number | boolean>]] boundElement.attributes)[name]
            end
            return nil
        end

        ---@param handler fun(ui: seb_XmlUi, id: tts__UIElement_Id): void
        local function onBoundId(handler)
            local id = self.getId()
            if boundUi and id then
                handler(--[[---@not nil]] boundUi, --[[---@not nil]] id)
            else
                Logger.debug("Not bound")
            end
        end

        ---@param name string
        ---@param value number | string | boolean
        function self.setAttribute(name, value)
            if not boundElement.attributes then
                (--[[---@type table<string, any>]] boundElement).attributes = {}
            end
            (--[[---@type table<string, any>]] boundElement.attributes)[name] = value

            onBoundId(function(ui, id) ui.setAttribute(id, name, value) end)
        end

        ---@return nil | string
        function self.getId()
            return --[[---@type nil | string]] getAttribute("id")
        end

        ---@param ui seb_XmlUi
        function self.bindUi(ui)
            boundUi = ui
        end

        ---@param uiElement seb_XmlUi_Element
        function self.addChild(uiElement)
            table.insert(children, uiElement)
        end

        ---@param child number
        ---@return seb_XmlUi_Element
        function self.getChild(child)
            return children[child]
        end

        function self.clearElements()
            children = {}
        end

        ---@return tts__UIElement
        function self.getXmlElement()
            -- the type cast is obviously bogus, but I didn't find another clear way to get rid of the wrong type error
            local unwrappedElement = --[[---@type tts__UILayoutElement]] boundElement
            unwrappedElement.children = TableUtil.map(children, function(c) return c.getXmlElement() end)
            return unwrappedElement
        end

        function self.show()
            onBoundId(function(ui, id) ui.show(id) end)
        end

        function self.hide()
            onBoundId(function(ui, id) ui.hide(id) end)
        end

        ---@param value number
        function self.setWidth(value)
            self.setAttribute("width", value)
        end

        ---@param value number
        function self.setHeight(value)
            self.setAttribute("height", value)
        end

        ---@param value string
        function self.setTooltip(value)
            self.setAttribute("tooltip", value)
        end

        ---@param value seb_XmlUi_Color
        function self.setTooltipBackgroundColor(value)
            self.setAttribute("tooltipBackgroundColor", toColor(value))
        end

        ---@param value seb_XmlUi_Color
        function self.setTooltipBorderColor(value)
            self.setAttribute("tooltipBorderColor", toColor(value))
        end

        ---@param value seb_XmlUi_Color
        function self.setTooltipTextColor(value)
            self.setAttribute("tooltipTextColor", toColor(value))
        end

        ---@return tts__UIElement_Tag
        function self.getType()
            return boundElement.tag
        end

        return self
    end
}))

setmetatable(XmlUiDefaults, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIDefaultsElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiText, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UITextElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiInputField, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIInputFieldElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiButton, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIButtonElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiImage, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIImageElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiToggle, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIToggleElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiToggleButton, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIToggleButtonElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiToggleGroup, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIToggleGroupElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiDropdown, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIDropdownElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        ---@param value seb_XmlUi_OptionAttributes
        function self.addOption(attributes)
            local option = XmlUi.createOption(attributes)
            self.addChild(option)
            return option
        end

        return self
    end
}))

setmetatable(XmlUiOption, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIOptionElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiSlider, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UISliderElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiProgressBar, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIProgressBarElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiPanel, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIPanelElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiAxisLayout, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIHorizontalLayoutElement | tts__UIVerticalLayoutElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiGridLayout, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIGridLayoutElement
    __call = function(_, element)
        local self = XmlUiElement(element)

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

setmetatable(XmlUiTableLayout, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UITableLayoutElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        ---@overload fun(): seb_XmlUi_Row
        ---@param attributes seb_XmlUi_RowAttributes
        ---@return seb_XmlUi_Row
        function self.addRow(attributes)
            local row = XmlUi.createRow(attributes)
            self.addChild(row)
            return row
        end

        return self
    end
}))

setmetatable(XmlUiRow, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIRowElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        local super_addChild = self.addChild

        ---@overload fun(): seb_XmlUi_Cell
        ---@param attributes seb_XmlUi_CellAttributes
        ---@return seb_XmlUi_Cell
        function self.addCell(attributes)
            local cell = XmlUi.createCell(attributes)
            self.addChild(cell)
            return cell
        end

        ---@param uiElement seb_XmlUi_Element
        function self.addChild(uiElement)
            if uiElement.getType() ~= "Cell" then
                local cell = XmlUi.createCell()
                cell.addChild(uiElement)
                super_addChild(cell)
            else
                super_addChild(uiElement)
            end
        end

        return self
    end
}))

setmetatable(XmlUiCell, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UICellElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

setmetatable(XmlUiScrollView, TableUtil.merge(getmetatable(XmlUiElement), {
    ---@param element tts__UIScrollViewElement
    __call = function(_, element)
        local self = XmlUiElement(element)

        return self
    end
}))

---@param tag tts__UIElement_Tag
---@param attributes nil | seb_XmlUi_Attributes
---@return seb_XmlUi_Element
local function createElement(tag, attributes)
    attributes = attributes or {}
    local ttsElement = { tag = tag, attributes = {}, children = {} }
    copyAttributes(ttsElement, attributes, Attributes.Basic)
    if Attributes[tag] ~= nil then
        copyAttributes(ttsElement, attributes, Attributes[tag])
    end
    if attributes.value then
        ttsElement.value = attributes.value
    end

    for name, value in pairs(attributes) do
        if name ~= "value" and value ~= nil and ttsElement.attributes[name] == nil then
            Logger.warn("Unmapped attribute '%s'!", name)
        end
    end

    return ElementFactory[tag](ttsElement)
end

---@overload fun(): seb_XmlUi_Text
---@param attributes seb_XmlUi_TextAttributes
---@return seb_XmlUi_Text
function XmlUi.createText(attributes)
    return --[[---@type seb_XmlUi_Text]] createElement("Text", attributes)
end

---@param attributes seb_XmlUi_ButtonAttributes
---@return seb_XmlUi_Button
function XmlUi.createButton(attributes)
    return --[[---@type seb_XmlUi_Button]] createElement("Button", attributes)
end

---@param attributes seb_XmlUi_ImageAttributes
---@return seb_XmlUi_Image
function XmlUi.createImage(attributes)
    return --[[---@type seb_XmlUi_Image]] createElement("Image", attributes)
end

---@param attributes seb_XmlUi_ToggleAttributes
---@return seb_XmlUi_Toggle
function XmlUi.createToggle(attributes)
    return --[[---@type seb_XmlUi_Toggle]] createElement("Toggle", attributes)
end

---@param attributes seb_XmlUi_DropdownAttributes
---@return seb_XmlUi_Dropdown
function XmlUi.createDropdown(attributes)
    return --[[---@type seb_XmlUi_Dropdown]] createElement("Dropdown", attributes)
end

---@param attributes seb_XmlUi_OptionAttributes
---@return seb_XmlUi_Option
function XmlUi.createOption(attributes)
    return --[[---@type seb_XmlUi_Option]] createElement("Option", attributes)
end

---@overload fun(): seb_XmlUi_Panel
---@param attributes seb_XmlUi_PanelAttributes
---@return seb_XmlUi_Panel
function XmlUi.createPanel(attributes)
    return --[[---@type seb_XmlUi_Panel]] createElement("Panel", attributes)
end

---@param attributes seb_XmlUi_GridLayoutAttributes
---@return seb_XmlUi_GridLayout
function XmlUi.createGridLayout(attributes)
    return --[[---@type seb_XmlUi_GridLayout]] createElement("GridLayout", attributes)
end

---@overload fun(): seb_XmlUi_AxisLayout
---@param attributes seb_XmlUi_AxisLayoutAttributes
---@return seb_XmlUi_AxisLayout
function XmlUi.createHorizontalLayout(attributes)
    return --[[---@type seb_XmlUi_AxisLayout]] createElement("HorizontalLayout", attributes)
end

---@overload fun(): seb_XmlUi_AxisLayout
---@param attributes seb_XmlUi_AxisLayoutAttributes
---@return seb_XmlUi_AxisLayout
function XmlUi.createVerticalLayout(attributes)
    return --[[---@type seb_XmlUi_AxisLayout]] createElement("VerticalLayout", attributes)
end

---@overload fun(): seb_XmlUi_TableLayout
---@param attributes seb_XmlUi_TableLayoutAttributes
---@return seb_XmlUi_TableLayout
function XmlUi.createTableLayout(attributes)
    return --[[---@type seb_XmlUi_TableLayout]] createElement("TableLayout", attributes)
end

---@overload fun(): seb_XmlUi_Row
---@param attributes seb_XmlUi_RowAttributes
---@return seb_XmlUi_Row
function XmlUi.createRow(attributes)
    return --[[---@type seb_XmlUi_Row]] createElement("Row", attributes)
end

---@overload fun(): seb_XmlUi_Cell
---@param attributes seb_XmlUi_CellAttributes
---@return seb_XmlUi_Cell
function XmlUi.createCell(attributes)
    return --[[---@type seb_XmlUi_Cell]] createElement("Cell", attributes)
end

---@overload fun(): seb_XmlUi_ScrollView
---@param attributes seb_XmlUi_ScrollViewAttributes
---@return seb_XmlUi_ScrollView
function XmlUi.createHorizontalScrollView(attributes)
    return --[[---@type seb_XmlUi_ScrollView]] createElement("HorizontalScrollView", attributes)
end

---@overload fun(): seb_XmlUi_ScrollView
---@param attributes seb_XmlUi_ScrollViewAttributes
---@return seb_XmlUi_ScrollView
function XmlUi.createVerticalScrollView(attributes)
    return --[[---@type seb_XmlUi_ScrollView]] createElement("VerticalScrollView", attributes)
end

return XmlUi
