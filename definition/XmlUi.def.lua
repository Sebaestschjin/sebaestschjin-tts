---@class seb_XmlUi_Container
---@class seb_XmlUi : seb_XmlUi_Container
---@class seb_XmlUi_Element : seb_XmlUi_Container
---@class seb_XmlUi_Button : seb_XmlUi_Element
---@class seb_XmlUi_Image : seb_XmlUi_Element
---@class seb_XmlUi_Panel : seb_XmlUi_Element
---@class seb_XmlUi_AxisLayout : seb_XmlUi_Element
---@class seb_XmlUi_GridLayout : seb_XmlUi_Element

---@shape seb_XmlUi_Attributes
---@field id nil | string
---@field width nil | number
---@field height nil | number
---@field offsetXY nil | seb_XmlUi_Vector2
---@field minWidth nil | number
---@field rectAlignment nil | tts__UIElement_Alignment
---@field active nil | boolean
---@field visibility nil | tts__PlayerColor | tts__PlayerColor[]
---@field showAnimation nil | tts__UIElement_ShowAnimation
---@field hideAnimation nil | tts__UIElement_HideAnimation
---@field tooltip nil | string
---@field tooltipBackgroundColor nil | tts__UIElement_Color
---@field onClick nil | seb_XmlUi_EventHandler
---@field onMouseDown nil | seb_XmlUi_EventHandler
---@field onMouseUp nil | seb_XmlUi_EventHandler
---@field onMouseEnter nil | seb_XmlUi_EventHandler
---@field onMouseExit nil | seb_XmlUi_EventHandler
---@field class nil | string
---@field color nil | tts__ColorShape
---@field allowDragging nil | boolean
---@field restrictDraggingToParentBounds nil | boolean
---@field returnToOriginalPositionWhenReleased nil | boolean

---@shape seb_XmlUi_ButtonAttributes : seb_XmlUi_Attributes
---@field value nil | string
---@field textColor nil | tts__ColorParameter

---@shape seb_XmlUi_ImageAttributes : seb_XmlUi_Attributes
---@field image URL
---@field preserveAspect nil | boolean

---@shape seb_XmlUi_PanelAttributes : seb_XmlUi_Attributes

---@shape seb_XmlUi_GridLayoutAttributes : seb_XmlUi_Attributes
---@field padding nil | seb_XmlUi_Padding @Default {0, 0, 0, 0}
---@field spacing nil | seb_XmlUi_Size @Default {0, 0}
---@field cellSize nil | seb_XmlUi_Size @Default {100, 100}
---@field startCorner nil | tts__UIElement_Alignment_Corner @Default "UpperLeft"
---@field startAxis nil | tts__UIElement_Alignment_Axis @Default "Horizontal"
---@field childAlignment nil | tts__UIElement_Alignment @Default "UpperLeft"
---@field constraint nil | tts__UIGridLayoutElement_Constraint @Default "Flexible"
---@field constraintCount nil | number @Default 2

---@shape seb_XmlUi_AxisLayoutAttributes : seb_XmlUi_Attributes

---@alias seb_XmlUi_EventHandler seb_XmlUi_CoolEventHandler | tts__UIElement_CallbackFunctionName

---@shape seb_XmlUi_CoolEventHandler
---@field [1] tts__Object
---@field [2] string

---@shape seb_XmlUi_Vector2
---@field [1] number
---@field [2] number

---@shape seb_XmlUi_Vector4
---@field [1] number
---@field [2] number
---@field [3] number
---@field [4] number

---@alias seb_XmlUi_Padding number | seb_XmlUi_Vector4
---@alias seb_XmlUi_Size number | seb_XmlUi_Vector2