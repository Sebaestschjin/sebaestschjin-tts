local Logger = require("sebaestschjin-tts.Logger")
local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiContainer = require("sebaestschjin-tts.xmlui.XmlUiContainer")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")

---@class seb_XmlUi_Element : seb_XmlUi_Container

---@class seb_XmlUi_Element_Static
---@overload fun(element: tts__UIElement): seb_XmlUi_Element
local XmlUiElement = {}

---@shape seb_XmlUi_Attributes
---@field id nil | string @A unique string used to identify the element from Lua scripting.
---@field active nil | boolean @Specifies whether or not this element and its children are visible and contribute to layout. Modifying this via script will not trigger animations.
---@field rectAlignment nil | tts__UIElement_Alignment @The element's anchor and pivot point, relative to its parent element.
---@field width nil | number @ 	The width of this element in pixels or as a percentage of the width of its parent.
---@field height nil | number @The height of this element in pixels or as a percentage of the height of its parent.
---@field position nil | seb_Vector3
---@field rotation nil | seb_Vector3
---@field scale nil | seb_Vector3
---@field offsetXY nil | seb_Vector2 @An offset to the position of this element, e.g. a value of -32 10 will cause this element to be 10 pixels up and 32 pixels to the left of where it would otherwise be.
---@field alignment nil | tts__UIElement_Alignment @Typographic alignment of the text within its bounding box.
---@field visibility nil | seb_XmlUi_VisibilityTarget | seb_XmlUi_VisibilityTarget[] @A list of visibility targets. An element is always treated as inactive to players not specified here.
---@field showAnimation nil | tts__UIElement_ShowAnimation @Animation to play when show() is called for the element.
---@field showAnimationDelay nil | number @Time in seconds to wait before playing this element's show animation. Useful for staggering the animations of multiple elements.
---@field hideAnimation nil | tts__UIElement_HideAnimation @Animation to play when hide() is called for the element.
---@field hideAnimationDelay nil | number @Time in seconds to wait before playing this element's hide animation. Useful for staggering the animations of multiple elements.
---@field animationDuration nil | number @Time in seconds that show/hide animations take to play.
---@field tooltip nil | string
---@field tooltipBackgroundColor nil | seb_XmlUi_Color
---@field tooltipBackgroundImage nil | tts__UIAssetName
---@field tooltipBorderColor nil | seb_XmlUi_Color
---@field tooltipBorderImage nil | tts__UIAssetName
---@field tooltipOffset nil | integer
---@field tooltipPosition nil | tts__UITooltipPosition
---@field tooltipTextColor nil | seb_XmlUi_Color
---@field onClick nil | seb_XmlUi_EventHandler
---@field onMouseDown nil | seb_XmlUi_EventHandler
---@field onMouseUp nil | seb_XmlUi_EventHandler
---@field onMouseEnter nil | seb_XmlUi_EventHandler
---@field onMouseExit nil | seb_XmlUi_EventHandler
---@field class nil | string | string[] @A list of classes. An element will inherit attributes from any of its classes defined in Defaults.
---@field color nil | seb_XmlUi_Color @Color of the text. Elements that also take an image color use textColor for this.
---@field font nil | tts__UIAssetName
---@field fontStyle nil | tts__UIElement_FontStyle @Typographic emphasis on the text.
---@field fontSize nil | number @Height of the text in pixels.
---@field shadow nil | tts__ColorShape @Defines the shadow color of this element.
---@field shadowDistance nil | seb_Vector2 @Defines the distance of the shadow for this element.
---@field outline nil | tts__ColorShape @Defines the outline color of this element.
---@field outlineSize nil | seb_Vector2 @Defines the size of this elements outline.
---@field resizeTextForBestFit nil | boolean @If set then fontSize is ignored and the text will be sized to be as large as possible while still fitting within its bounding box.
---@field resizeTextMinSize nil | number @When resizeTextForBestFit is set, text will not be sized smaller than this.
---@field resizeTextMaxSize nil | number @When resizeTextForBestFit is set, text will not be sized larger than this.
---@field horizontalOverflow nil | tts__UITextElement_HorizontalOverflow @ Defines what happens when text extends beyond the left or right edges of its bounding box.
---@field verticalOverflow nil | tts__UITextElement_VerticalOverflow @Defines what happens when text extends beyond the top or bottom edges of its bounding box.
---@field allowDragging nil | boolean @Allows the element to be dragged around.
---@field restrictDraggingToParentBounds nil | boolean @If set, prevents the element from being dragged outside the bounding box of its parent.
---@field returnToOriginalPositionWhenReleased nil | boolean @If this is set to true, then the element will return to its original position when it is released.
---@field ignoreLayout nil | boolean @If this element ignores its parent's layout group behavior and treats it as a regular Panel. (This means it would obey regular position/size attributes.)
---@field minWidth nil | number @Elements will not be sized thinner than this.
---@field minHeight nil | number @Elements will not be sized shorter than this.
---@field preferredWidth nil | number @If there is space after minWidths are sized, then element widths are sized according to this.
---@field preferredHeight nil | number @If there is space after minHeights are sized, then element heights are sized according to this.
---@field flexibleWidth nil | number @If there is additional space after preferredWidths are sized, defines how much the element expands to fill the available horizontal space, relative to other elements.
---@field flexibleHeight nil | number @If there is additional space after preferredHeightss are sized, defines how much the element expands to fill the available vertical space, relative to other elements.
---@field zIndex nil | integer

---@type table<string, seb_XmlUi_AttributeType>
local Attributes = {
    -- General
    id = XmlUiFactory.AttributeType.string,
    class = XmlUiFactory.AttributeType.string,
    active = XmlUiFactory.AttributeType.boolean,
    visibility = XmlUiFactory.AttributeType.players,
    -- Text
    text = XmlUiFactory.AttributeType.string,
    alignment = XmlUiFactory.AttributeType.string,
    color = XmlUiFactory.AttributeType.color,
    font = XmlUiFactory.AttributeType.string,
    fontStyle = XmlUiFactory.AttributeType.string,
    fontSize = XmlUiFactory.AttributeType.integer,
    resizeTextForBestFit = XmlUiFactory.AttributeType.boolean,
    resizeTextMinSize = XmlUiFactory.AttributeType.integer,
    resizeTextMaxSize = XmlUiFactory.AttributeType.integer,
    horizontalOverflow = XmlUiFactory.AttributeType.string,
    verticalOverflow = XmlUiFactory.AttributeType.string,
    -- Appearance
    shadow = XmlUiFactory.AttributeType.color,
    shadowDistance = XmlUiFactory.AttributeType.vector2,
    outline = XmlUiFactory.AttributeType.color,
    outlineSize = XmlUiFactory.AttributeType.vector2,
    -- Layout
    ignoreLayout = XmlUiFactory.AttributeType.boolean,
    minWidth = XmlUiFactory.AttributeType.integer,
    minHeight = XmlUiFactory.AttributeType.integer,
    preferredWidth = XmlUiFactory.AttributeType.integer,
    preferredHeight = XmlUiFactory.AttributeType.integer,
    flexibleWidth = XmlUiFactory.AttributeType.integer,
    flexibleHeight = XmlUiFactory.AttributeType.integer,
    -- Position/Size
    position = XmlUiFactory.AttributeType.vector3,
    rotation = XmlUiFactory.AttributeType.vector3,
    scale = XmlUiFactory.AttributeType.vector3,
    rectAlignment = XmlUiFactory.AttributeType.string,
    width = XmlUiFactory.AttributeType.integer,
    height = XmlUiFactory.AttributeType.integer,
    offsetXY = XmlUiFactory.AttributeType.vector2,
    -- Dragging
    allowDragging = XmlUiFactory.AttributeType.boolean,
    restrictDraggingToParentBounds = XmlUiFactory.AttributeType.boolean,
    returnToOriginalPositionWhenReleased = XmlUiFactory.AttributeType.boolean,
    -- Animation
    showAnimation = XmlUiFactory.AttributeType.string,
    hideAnimation = XmlUiFactory.AttributeType.string,
    showAnimationDelay = XmlUiFactory.AttributeType.float,
    hideAnimationDelay = XmlUiFactory.AttributeType.float,
    animationDuration = XmlUiFactory.AttributeType.float,
    -- Tooltip
    tooltip = XmlUiFactory.AttributeType.string,
    tooltipBackgroundColor = XmlUiFactory.AttributeType.color,
    tooltipBackgroundImage = XmlUiFactory.AttributeType.string,
    tooltipBorderColor = XmlUiFactory.AttributeType.color,
    tooltipBorderImage = XmlUiFactory.AttributeType.string,
    tooltipOffset = XmlUiFactory.AttributeType.integer,
    tooltipPosition = XmlUiFactory.AttributeType.string,
    tooltipTextColor = XmlUiFactory.AttributeType.color,
    -- Event
    onClick = XmlUiFactory.AttributeType.handler,
    onMouseEnter = XmlUiFactory.AttributeType.handler,
    onMouseExit = XmlUiFactory.AttributeType.handler,
    onMouseDown = XmlUiFactory.AttributeType.handler,
    onMouseUp = XmlUiFactory.AttributeType.handler,
    -- Custom
    zIndex = XmlUiFactory.AttributeType.integer,
}

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
        ---@param value tts__UIAttributeValue
        function self.setAttribute(name, value)
            if not boundElement.attributes then
                (--[[---@type table<string, any>]] boundElement).attributes = {}
            end
            (--[[---@type table<string, any>]] boundElement.attributes)[name] = value

            onBoundId(function(ui, id) ui.setAttribute(id, name, value) end)
        end

        ---@param name string
        ---@return number | string | boolean
        function self.getAttribute(name)
            if boundElement.attributes then
                local attributes = --[[---@type table<string, tts__UIAttributeValue>]] boundElement.attributes
                return attributes[name]
            end
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

        ---@return seb_XmlUi_Element[]
        function self.getChildren()
            return children
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

        ---@return integer
        function self.getZIndex()
            local attribute = self.getAttribute("zIndex")
            if not attribute then
                return 0
            end
            return --[[---@not nil]] tonumber(--[[---@type string]] attribute)
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
            self.setAttribute("tooltipBackgroundColor", XmlUiFactory.Converter.toColor(value))
        end

        ---@param value seb_XmlUi_Color
        function self.setTooltipBorderColor(value)
            self.setAttribute("tooltipBorderColor", XmlUiFactory.Converter.toColor(value))
        end

        ---@param value seb_XmlUi_Color
        function self.setTooltipTextColor(value)
            self.setAttribute("tooltipTextColor", XmlUiFactory.Converter.toColor(value))
        end

        ---@return tts__UIElement_Tag
        function self.getType()
            return boundElement.tag
        end

        return self
    end
}))

XmlUiFactory.register(nil, XmlUiElement, Attributes)

return XmlUiElement
