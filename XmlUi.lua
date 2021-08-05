local TableUtil = require("sebaestschjin-tts.TableUtil")
local XmlUiContainer = require("sebaestschjin-tts.xmlui.XmlUiContainer")
local XmlUiFactory = require("sebaestschjin-tts.xmlui.XmlUiFactory")

require("sebaestschjin-tts.xmlui.XmlUiAxisLayout")
require("sebaestschjin-tts.xmlui.XmlUiButton")
require("sebaestschjin-tts.xmlui.XmlUiCell")
require("sebaestschjin-tts.xmlui.XmlUiDefaults")
require("sebaestschjin-tts.xmlui.XmlUiDropdown")
require("sebaestschjin-tts.xmlui.XmlUiGridLayout")
require("sebaestschjin-tts.xmlui.XmlUiImage")
require("sebaestschjin-tts.xmlui.XmlUiInputField")
require("sebaestschjin-tts.xmlui.XmlUiOption")
require("sebaestschjin-tts.xmlui.XmlUiPanel")
require("sebaestschjin-tts.xmlui.XmlUiProgressBar")
require("sebaestschjin-tts.xmlui.XmlUiRow")
require("sebaestschjin-tts.xmlui.XmlUiScrollView")
require("sebaestschjin-tts.xmlui.XmlUiSlider")
require("sebaestschjin-tts.xmlui.XmlUiTableLayout")
require("sebaestschjin-tts.xmlui.XmlUiText")
require("sebaestschjin-tts.xmlui.XmlUiToggle")
require("sebaestschjin-tts.xmlui.XmlUiToggleButton")
require("sebaestschjin-tts.xmlui.XmlUiToggleGroup")

---@class seb_XmlUi : seb_XmlUi_Container

---@class seb_XmlUi_Static
---@overload fun(object: tts__Object): seb_XmlUi
local XmlUi = {}

XmlUi.Factory = XmlUiFactory

--- Values available for alignment attributes.
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

--- Values available for animation attributes.
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

--- Values available for fontStyle attributes.
XmlUi.FontStyle = {
    Bold = "Bold",
    BoldAndItalic = "BoldAndItalic",
    Italic = "Italic",
    Normal = "Normal",
}

XmlUi.GridLayout = {
    FixedColumnCount = "FixedColumnCount"
}

XmlUi.MouseEvent = {
    LeftClick = "-1",
    RightClick = "-2",
    MiddleClick = "-3",
    SingleTouch = "1",
    DoubleTouch = "2",
    TripleTouch = "3",
}

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

        ---@param childElements seb_XmlUi_Element[]
        ---@param elementId string
        local function findElementById(childElements, elementId)
            for _, element in pairs(childElements) do
                if element.getId() == elementId then
                    return element
                end
                local inChild = findElementById(element.getChildren(), elementId)
                if inChild then
                    return inChild
                end
            end
        end

        ---@param elementId tts__UIElement_Id
        ---@return nil | seb_XmlUi_Element
        function self.findElement(elementId)
            return findElementById(children, elementId)
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

            for i, child in ipairs(children) do
                if element.getZIndex() < child.getZIndex() then
                    table.insert(children, i, element)
                    return
                end
            end

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

        ---@param assetList tts__UIAsset[]
        function self.updateAssets(assetList)
            for _, asset in ipairs(assetList) do
                self.updateAsset(asset.name, asset.url)
            end
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

return XmlUi
