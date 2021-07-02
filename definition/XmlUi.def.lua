---@class seb_XmlUi_Container
---@class seb_XmlUi : seb_XmlUi_Container
---@class seb_XmlUi_Element : seb_XmlUi_Container
---@class seb_XmlUi_Defaults : seb_XmlUi_Element
---@class seb_XmlUi_Text : seb_XmlUi_Element
---@class seb_XmlUi_InputField : seb_XmlUi_Element
---@class seb_XmlUi_Button : seb_XmlUi_Element
---@class seb_XmlUi_Image : seb_XmlUi_Element
---@class seb_XmlUi_Toggle : seb_XmlUi_Element
---@class seb_XmlUi_ToggleButton : seb_XmlUi_Element
---@class seb_XmlUi_ToggleGroup : seb_XmlUi_Element
---@class seb_XmlUi_Dropdown : seb_XmlUi_Element
---@class seb_XmlUi_Option : seb_XmlUi_Element
---@class seb_XmlUi_Slider : seb_XmlUi_Element
---@class seb_XmlUi_ProgressBar : seb_XmlUi_Element
---@class seb_XmlUi_Panel : seb_XmlUi_Element
---@class seb_XmlUi_AxisLayout : seb_XmlUi_Element
---@class seb_XmlUi_GridLayout : seb_XmlUi_Element
---@class seb_XmlUi_TableLayout : seb_XmlUi_Element
---@class seb_XmlUi_Row : seb_XmlUi_Element
---@class seb_XmlUi_Cell : seb_XmlUi_Element
---@class seb_XmlUi_ScrollView : seb_XmlUi_Element

---@shape seb_XmlUi_Attributes
---@field id nil | string @A unique string used to identify the element from Lua scripting.
---@field active nil | boolean @Specifies whether or not this element and its children are visible and contribute to layout. Modifying this via script will not trigger animations.
---@field rectAlignment nil | tts__UIElement_Alignment @The element's anchor and pivot point, relative to its parent element.
---@field width nil | number @ 	The width of this element in pixels or as a percentage of the width of its parent.
---@field height nil | number @The height of this element in pixels or as a percentage of the height of its parent.
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

---@shape seb_XmlUi_TextAttributes : seb_XmlUi_Attributes
---@field text nil | string
---@field value nil | string
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_ButtonAttributes : seb_XmlUi_Attributes
---@field text nil | string
---@field value nil | string
---@field textColor nil | seb_XmlUi_Color
---@field colors nil | seb_XmlUi_ColorBlock
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_ImageAttributes : seb_XmlUi_Attributes
---@field image URL
---@field preserveAspect nil | boolean
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_ToggleAttributes : seb_XmlUi_Attributes
---@field onValueChanged nil | seb_XmlUi_EventHandler
---@field isOn nil | boolean
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_DropdownAttributes : seb_XmlUi_Attributes
---@field arrowColor nil | seb_XmlUi_Color
---@field arrowImage nil | tts__UIAssetName
---@field checkColor nil | seb_XmlUi_Color
---@field checkImage nil | tts__UIAssetName
---@field dropdownBackgroundColor nil | seb_XmlUi_Color
---@field dropdownBackgroundImage nil | tts__UIAssetName
---@field image nil | tts__UIAssetName @The image used as the background for a closed dropdown.
---@field itemBackgroundColors nil | seb_XmlUi_ColorBlock
---@field itemHeight nil | number
---@field itemTextColor nil | seb_XmlUi_Color
---@field onValueChanged nil | seb_XmlUi_EventHandler
---@field scrollbarColors nil | seb_XmlUi_ColorBlock
---@field scrollbarImage nil | tts__UIAssetName
---@field textColor nil | seb_XmlUi_Color
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_OptionAttributes : seb_XmlUi_Attributes
---@field value number | string
---@field selected nil | boolean
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_PanelAttributes : seb_XmlUi_Attributes
---@field [any] nil @All other fields are invalid

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

---@shape seb_XmlUi_AxisLayoutAttributes : seb_XmlUi_Attributes
---@field childAlignment nil | tts__UIElement_Alignment
---@field childForceExpandWidth nil | boolean
---@field childForceExpandHeight nil | boolean
---@field padding nil | seb_XmlUi_Padding
---@field spacing nil | integer
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_TableLayoutAttributes : seb_XmlUi_Attributes
---@field columnWidths nil | number[]
---@field padding nil | seb_XmlUi_Padding
---@field rowBackgroundColor nil | seb_XmlUi_Color | 'clear'
---@field rowBackgroundImage nil | tts__UIAssetName
---@field cellBackgroundColor nil | seb_XmlUi_Color | 'clear'
---@field cellBackgroundImage nil | tts__UIAssetName
---@field cellPadding nil | seb_XmlUi_Padding
---@field autoCalculateHeight nil | boolean
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_RowAttributes : seb_XmlUi_Attributes
---@field dontUseTableRowBackground nil | boolean
---@field image nil | tts__UIAssetName
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_CellAttributes : seb_XmlUi_Attributes
---@field columnSpan nil | integer @Default 1
---@field dontUseTableCellBackground nil |  boolean @Default false
---@field image nil | string
---@field overrideGlobalCellPadding nil | boolean @Default false
---@field padding nil | seb_XmlUi_Padding
---@field [any] nil @All other fields are invalid

---@shape seb_XmlUi_ScrollViewAttributes : seb_XmlUi_Attributes
---@field scrollbarBackgroundColor nil | seb_XmlUi_Color
---@field scrollbarColors nil | seb_XmlUi_ColorBlock
---@field [any] nil @All other fields are invalid

---@alias seb_XmlUi_VisibilityTarget tts__PlayerColor | tts__PlayerTeam | tts__PlayerRole

---@alias seb_XmlUi_EventHandler seb_XmlUi_ObjectEventHandler | tts__UIElement_CallbackFunctionName

---@shape seb_XmlUi_ObjectEventHandler
---@field [1] tts__Object @The object on which the function should be called.
---@field [2] tts__UIElement_CallbackFunctionName @The function to call.

---@alias seb_XmlUi_Padding number | seb_Vector4 | seb_XmlUi_Padding_Char | seb_XmlUi_Padding_AxisChar
---@alias seb_XmlUi_Size number | seb_Vector4
---@alias seb_XmlUi_Color tts__ColorParameter | string
---@alias seb_XmlUi_ColorBlock seb_XmlUi_Color[]

---@shape seb_XmlUi_Padding_Char
---@field l integer
---@field r integer
---@field t integer
---@field b integer

---@shape seb_XmlUi_Padding_AxisChar
---@field h integer
---@field v integer