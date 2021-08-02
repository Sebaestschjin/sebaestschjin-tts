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