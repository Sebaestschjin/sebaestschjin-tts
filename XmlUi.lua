local Logger = require("sebaestschjin-tts.Logger")
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

XmlUi.Alignment = {
    UpperLeft = "UpperLeft",
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
    GridLayout = XmlUiGridLayout
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

---@param value seb_XmlUi_Color
---@return string
local function toColor(value)
    if (--[[---@type tts__CharColorShape]] value).r ~= nil then
        local charColor = --[[---@type tts__CharColorShape]] value
        if charColor.a == nil then
            return string.format("rgb(%s,%s,%s)", charColor.r, charColor.g, charColor.b)
        end
        return string.format("rgba(%s,%s,%s)", charColor.r, charColor.g, charColor.b, charColor.a)
    elseif (--[[---@type tts__NumColorShape]] value)[1] ~= nil then
        local numColor = --[[---@type tts__NumColorShape]] value
        if numColor[4] == nil then
            return string.format("rgb(%s,%s,%s)", numColor[1], numColor[2], numColor[3])
        end
        return string.format("rgba(%s,%s,%s,%s)", numColor[1], numColor[2], numColor[3], numColor[4])
    else
        return --[[---@type string]] value
    end
end

---@param value seb_XmlUi_ColorBlock
---@return string
local function toColorBlock(value)
    return table.concat(TableUtil.map(value, toColor), "|")
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

local function toList(value)
    return toConcatenatedString(value, " ")
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
    handler = "handler",
    color = "color",
    colorBlock = "colorBlock",
    players = "players",
    vector2 = "vector2",
}

---@type table<string, fun(value: any): any>
local AttributeTypeMapper = {
    [AttributeType.string] = identity,
    [AttributeType.integer] = identity,
    [AttributeType.float] = identity,
    [AttributeType.boolean] = identity,
    [AttributeType.handler] = toHandlerFunction,
    [AttributeType.color] = toColor,
    [AttributeType.colorBlock] = toColorBlock,
    [AttributeType.players] = toPlayerColors,
    [AttributeType.vector2] = toList,
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
        -- Event
        onClick = AttributeType.handler,
        onMouseEnter = AttributeType.handler,
        onMouseExit = AttributeType.handler,
        onMouseDown = AttributeType.handler,
        onMouseUp = AttributeType.handler,
    },
    HorizontalLayout = {
        childAlignment = AttributeType.string,
        childForceExpandWidth = AttributeType.boolean,
        childForceExpandHeight = AttributeType.boolean,
    },
    Button = {
        textColor = AttributeType.color,
    },
    Dropdown = {
        itemHeight = AttributeType.integer,
        arrowColor = AttributeType.color,
        checkColor = AttributeType.color,
        dropdownBackgroundColor = AttributeType.color,
        itemBackgroundColors = AttributeType.colorBlock,
        itemTextColor = AttributeType.color,
        scrollbarColors = AttributeType.color,
        textColor = AttributeType.color,
        onValueChanged = AttributeType.handler,
    },
    GridLayout = {
        constraint = AttributeType.string,
        constraintCount = AttributeType.integer,
    },
    Image = {
        image = AttributeType.string,
        preserveAspect = AttributeType.boolean,
    },
    Toggle = {
        isOn = AttributeType.boolean,
    },
    Option = {
        selected = AttributeType.boolean,
    },
    VerticalLayout = {
        childAlignment = AttributeType.string,
        childForceExpandWidth = AttributeType.boolean,
        childForceExpandHeight = AttributeType.boolean,
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

        ---@param attributes seb_XmlUi_TextAttributes
        ---@return seb_XmlUi_Text
        function self.addText(attributes)
            local button = XmlUi.createText(attributes)
            self.addChild(button)
            return button
        end

        ---@param attributes seb_XmlUi_ButtonAttributes
        ---@return seb_XmlUi_Button
        function self.addButton(attributes)
            local button = XmlUi.createButton(attributes)
            self.addChild(button)
            return button
        end

        ---@param attributes seb_XmlUi_ImageAttributes
        ---@return seb_XmlUi_Image
        function self.addImage(attributes)
            local image = XmlUi.createImage(attributes)
            self.addChild(image)
            return image
        end

        ---@param attributes seb_XmlUi_ToggleAttributes
        ---@return seb_XmlUi_Toggle
        function self.addToggle(attributes)
            local toggle = XmlUi.createToggle(attributes)
            self.addChild(toggle)
            return toggle
        end

        ---@param attributes seb_XmlUi_DropdownAttributes
        ---@return seb_XmlUi_Dropdown
        function self.addDropdown(attributes)
            local dropdown = XmlUi.createDropdown(attributes)
            self.addChild(dropdown)
            return dropdown
        end

        ---@param attributes seb_XmlUi_AxisLayoutAttributes
        ---@return seb_XmlUi_AxisLayout
        function self.addVerticalLayout(attributes)
            local layout = XmlUi.createVerticalLayout(attributes)
            self.addChild(layout)
            return layout
        end

        ---@param attributes seb_XmlUi_AxisLayoutAttributes
        ---@return seb_XmlUi_AxisLayout
        function self.addHorizontalLayout(attributes)
            local layout = XmlUi.createHorizontalLayout(attributes)
            self.addChild(layout)
            return layout
        end

        ---@param attributes seb_XmlUi_GridLayoutAttributes
        ---@return seb_XmlUi_GridLayout
        function self.addGridLayout(attributes)
            local gridLayout = XmlUi.createGridLayout(attributes)
            self.addChild(gridLayout)
            return gridLayout
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

---@param tag tts__UIElement_Tag
---@param attributes seb_XmlUi_Attributes
---@return seb_XmlUi_Element
local function createElement(tag, attributes)
    local ttsElement = { tag = tag, attributes = {}, children = {} }
    copyAttributes(ttsElement, attributes, Attributes.Basic)
    if Attributes[tag] ~= nil then
        copyAttributes(ttsElement, attributes, Attributes[tag])
    end
    if attributes.value then
        ttsElement.value = attributes.value
    end

    return ElementFactory[tag](ttsElement)
end

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

return XmlUi
