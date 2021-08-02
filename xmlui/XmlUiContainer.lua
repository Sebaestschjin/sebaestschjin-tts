local Logger = require("sebaestschjin-tts.Logger")
local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")

---@class seb_XmlUi_Container

---@class seb_XmlUi_Container_Static
---@overload fun(): seb_XmlUi_Container
local XmlUiContainer = {}

setmetatable(XmlUiContainer, {
    __call = function(_)
        local self = --[[---@type seb_XmlUi_Container]] {}

        ---@param unwrappedElements nil | tts__UIElement[]
        ---@return seb_XmlUi_Element[]
        function self._wrapChildren(unwrappedElements)
            local elements = --[[---@type seb_XmlUi_Element[] ]] {}
            for _, element in TableUtil.ipairs(--[[---@type tts__UIElement[] ]] unwrappedElements) do
                local uiElement = XmlUiFactory.wrapElement(element)
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
            return addToChildren(XmlUiFactory.createText(attributes))
        end

        ---@param attributes seb_XmlUi_ButtonAttributes
        ---@return seb_XmlUi_Button
        function self.addButton(attributes)
            return addToChildren(XmlUiFactory.createButton(attributes))
        end

        ---@param attributes seb_XmlUi_ImageAttributes
        ---@return seb_XmlUi_Image
        function self.addImage(attributes)
            return addToChildren(XmlUiFactory.createImage(attributes))
        end

        ---@param attributes seb_XmlUi_ToggleAttributes
        ---@return seb_XmlUi_Toggle
        function self.addToggle(attributes)
            return addToChildren(XmlUiFactory.createToggle(attributes))
        end

        ---@param attributes seb_XmlUi_DropdownAttributes
        ---@return seb_XmlUi_Dropdown
        function self.addDropdown(attributes)
            return addToChildren(XmlUiFactory.createDropdown(attributes))
        end

        ---@overload fun(): seb_XmlUi_Panel
        ---@param attributes seb_XmlUi_PanelAttributes
        ---@return seb_XmlUi_Panel
        function self.addPanel(attributes)
            return addToChildren(XmlUiFactory.createPanel(attributes))
        end

        ---@overload fun(): seb_XmlUi_AxisLayout
        ---@param attributes seb_XmlUi_AxisLayoutAttributes
        ---@return seb_XmlUi_AxisLayout
        function self.addVerticalLayout(attributes)
            return addToChildren(XmlUiFactory.createVerticalLayout(attributes))
        end

        ---@overload fun(): seb_XmlUi_AxisLayout
        ---@param attributes seb_XmlUi_AxisLayoutAttributes
        ---@return seb_XmlUi_AxisLayout
        function self.addHorizontalLayout(attributes)
            return addToChildren(XmlUiFactory.createHorizontalLayout(attributes))
        end

        ---@param attributes seb_XmlUi_TableLayoutAttributes
        ---@return seb_XmlUi_TableLayout
        function self.addTableLayout(attributes)
            return addToChildren(XmlUiFactory.createTableLayout(attributes))
        end

        ---@param attributes seb_XmlUi_GridLayoutAttributes
        ---@return seb_XmlUi_GridLayout
        function self.addGridLayout(attributes)
            return addToChildren(XmlUiFactory.createGridLayout(attributes))
        end

        ---@param attributes seb_XmlUi_ScrollViewAttributes
        ---@return seb_XmlUi_ScrollView
        function self.addHorizontalScrollView(attributes)
            return addToChildren(XmlUiFactory.createHorizontalScrollView(attributes))
        end

        ---@param attributes seb_XmlUi_ScrollViewAttributes
        ---@return seb_XmlUi_ScrollView
        function self.addVerticalScrollView(attributes)
            return addToChildren(XmlUiFactory.createVerticalScrollView(attributes))
        end

        return self
    end
})

return XmlUiContainer
