---@shape seb_

---@shape seb_CustomObject
---@field name nil | string
---@field description nil | string
---@field locked nil | boolean @Default false
---@field snapToGrid nil | boolean @Default true
---@field tint nil | tts__CharColorShape

---@shape seb_Transform
---@field position nil | tts__VectorShape
---@field rotation nil | tts__VectorShape
---@field scale nil | tts__VectorShape

---@shape seb_CustomObject_Bag : seb_CustomObject
---@field objects nil | tts__ObjectState[]

---@shape seb_CustomObject_DeckCustom : seb_CustomObject
---@field cards tts__CardCustomState[]

---@shape seb_CustomObject_CardCustom : seb_CustomObject
---@field image string
---@field imageBack nil | string @Defaults to the same image as the front image

---@shape seb_CustomObject_Token : seb_CustomObject
---@field image URL
---@field thickness nil | number @Defaults to 0.2
---@field mergeDistance nil | number @Defaults to 15
---@field stackable nil | boolean @Defaults to false

---@shape seb_CustomObject_Tile : seb_CustomObject
---@field image URL
---@field imageBottom nil | URL @Defaults to the top image
---@field type nil | tts__TileType @Defaults to 0 (Rectangle)
---@field thickness nil | number @Defaults to 0.5
---@field stackable nil | boolean @Defaults to false
---@field stretch nil | boolean @Defaults to true

---@shape seb_CustomObject_Model : seb_CustomObject
---@field mesh string
---@field diffuse nil | string
---@field collider nil | string
---@field type nil | tts__ModelType
---@field material nil | tts__MaterialType