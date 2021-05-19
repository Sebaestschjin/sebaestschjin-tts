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

---@class seb_XmlUi_Button_Static
---@overload fun(element: tts__UIButtonElement): seb_XmlUi_Button
local XmlUiButton = {}

---@class seb_XmlUi_Image_Static
---@overload fun(element: tts__UIImageElement): seb_XmlUi_Image
local XmlUiImage = {}

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

XmlUi.Animation = {
    Grow = "Grow",
    Shrink = "Shrink",
}

XmlUi.GridLayout = {
    FixedColumnCount = "FixedColumnCount"
}

---@alias seb_XmlUi_FactoryMethod fun(element: tts__UIElement): seb_XmlUi_Element
---@shape seb_XmlUi_Factory
---@field [tts__UIElement_Tag] seb_XmlUi_FactoryMethod
local ElementFactory = {
    Button = --[[---@type seb_XmlUi_FactoryMethod]] XmlUiButton,
    Image = --[[---@type seb_XmlUi_FactoryMethod]] XmlUiImage,
    GridLayout = --[[---@type seb_XmlUi_FactoryMethod]] XmlUiGridLayout
}

---@param value tts__ColorParameter
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

---@overload fun(element, attributes, name: string): void
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

setmetatable(XmlUiContainer, {
    __call = function(_)
        local self = --[[---@type seb_XmlUi_Container]] {}

        ---@param unwrappedElements nil | tts__UIElement[]
        ---@return seb_XmlUi_Element[]
        function self._wrapChildren(unwrappedElements)
            local elements = --[[---@type seb_XmlUi_Element[] ]] {}
            for _, element in TableUtil.ipairs(unwrappedElements) do
                local factory = ElementFactory[element.tag]
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

        ---@param uiElement seb_XmlUi_Element
        function self.addChild(uiElement) end

        ---@param child number
        ---@return seb_XmlUi_Element
        function self.getChild(child) end

        function self.clearElements() end

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
        function self.addElement(element)
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
                return (--[[---@not nil]] boundElement.attributes)[name]
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
                boundElement.attributes = {}
            end
            (--[[---@not nil]] boundElement.attributes)[name] = value

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
            local unwrappedElement = boundElement
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

---@param element tts__UIElement
---@param attributes seb_XmlUi_Attributes
local function copyBaseAttributes(element, attributes)
    ---@overload fun(value: any, separator: string): string
    ---@param value any
    ---@param separator string
    ---@param multiple number
    ---@return nil | string
    local function asConcatenatedString(value, separator, multiple)
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

    ---@param value nil | seb_XmlUi_EventHandler
    ---@return string
    local function toHandlerFunction(value)
        if type(value) == "table" then
            local asTable = --[[---@type seb_XmlUi_CoolEventHandler]] value
            return asTable[1].getGUID() .. "/" .. asTable[2]
        end
        return --[[---@type string]] value
    end

    local function toList(value)
        return asConcatenatedString(value, " ")
    end

    local function toPlayerColors(value)
        return asConcatenatedString(value, "|")
    end

    copyAttribute(element, attributes, "id")

    copyAttribute(element, attributes, "height")
    copyAttribute(element, attributes, "width")
    copyAttribute(element, attributes, "offsetXY", toList)
    copyAttribute(element, attributes, "minWidth")
    copyAttribute(element, attributes, "rectAlignment")

    copyAttribute(element, attributes, "active")
    copyAttribute(element, attributes, "visibility", toPlayerColors)

    copyAttribute(element, attributes, "class")
    copyAttribute(element, attributes, "color", toColor)
    copyAttribute(element, attributes, "showAnimation")
    copyAttribute(element, attributes, "hideAnimation")

    copyAttribute(element, attributes, "tooltip")
    copyAttribute(element, attributes, "tooltipBackgroundColor")

    copyAttribute(element, attributes, "onClick", toHandlerFunction)
    copyAttribute(element, attributes, "onMouseEnter", toHandlerFunction)
    copyAttribute(element, attributes, "onMouseExit", toHandlerFunction)
    copyAttribute(element, attributes, "onMouseDown", toHandlerFunction)
    copyAttribute(element, attributes, "onMouseUp", toHandlerFunction)

    copyAttribute(element, attributes, "allowDragging")
    copyAttribute(element, attributes, "restrictDraggingToParentBounds")
    copyAttribute(element, attributes, "returnToOriginalPositionWhenReleased")
end

---@param attributes seb_XmlUi_ButtonAttributes
---@return seb_XmlUi_Button
function XmlUi.createButton(attributes)
    local element = {
        tag = "Button",
        attributes = --[[---@type tts__UIButtonElement_Attributes]] {
        },
    }
    copyBaseAttributes(element, attributes)
    copyAttribute(element, attributes, "textColor", toColor)

    if attributes.value then
        element.value = attributes.value
    end

    return XmlUiButton(element)
end

---@param attributes seb_XmlUi_ImageAttributes
---@return seb_XmlUi_Image
function XmlUi.createImage(attributes)
    local element = {
        tag = "Image",
        attributes = --[[---@type tts__UIImageElement_Attributes]] {
            image = attributes.image,
            preserveAspect = attributes.preserveAspect,
        },
    }
    copyBaseAttributes(element, attributes)

    return XmlUiImage(element)
end

---@param attributes seb_XmlUi_PanelAttributes
---@return seb_XmlUi_Panel
function XmlUi.createPanel(attributes)
    local element = {
        tag = "Panel",
        attributes = --[[---@type tts__UIPanelElement_Attributes]] {
        },
        children = --[[---@type tts__UIElement[] ]]{},
    }
    copyBaseAttributes(element, attributes)

    return XmlUiPanel(element)
end

---@param attributes seb_XmlUi_GridLayoutAttributes
---@return seb_XmlUi_GridLayout
function XmlUi.createGridLayout(attributes)
    local element = {
        tag = "GridLayout",
        attributes = --[[---@type tts__UIGridLayoutElement_Attributes]] {
            constraint = attributes.constraint,
            constraintCount = attributes.constraintCount,
        },
        children = --[[---@type tts__UIElement[] ]]{},
    }
    copyBaseAttributes(element, attributes)

    return XmlUiGridLayout(element)
end

---@param attributes seb_XmlUi_AxisLayoutAttributes
---@param direction "Horizontal" | "Vertical"
---@return seb_XmlUi_AxisLayout
local function createAxisLayout(attributes, direction)
    local element = --[[---@type tts__UILayoutElement]] {
        tag = direction .. "Layout",
        attributes = {},
        children = --[[---@type tts__UIElement[] ]]{},
    }
    copyBaseAttributes(element, attributes)

    return XmlUiAxisLayout(element)
end

---@overload fun(): seb_XmlUi_AxisLayout
---@param attributes seb_XmlUi_AxisLayoutAttributes
---@return seb_XmlUi_AxisLayout
function XmlUi.createHorizontalLayout(attributes)
    return createAxisLayout(attributes or {}, "Horizontal")
end

---@overload fun(): seb_XmlUi_AxisLayout
---@param attributes seb_XmlUi_AxisLayoutAttributes
---@return seb_XmlUi_AxisLayout
function XmlUi.createVerticalLayout(attributes)
    return createAxisLayout(attributes or {}, "Vertical")
end

return XmlUi
