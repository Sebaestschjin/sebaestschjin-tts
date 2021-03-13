---@shape seb_

---@shape seb_CustomObject
---@field name nil | string
---@field description nil | string
---@field locked nil | boolean @Default false
---@field snapToGrid nil | boolean @Default true
---@field tint nil | tts__ColorShape
---@field script nil | string
---@field state nil | string | table
---@field tags nil | string[]

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

---@shape seb_CustomObject_LayoutZone : seb_CustomObject
---@field includeFaceUp nil | boolean @Defaults to true
---@field includeFaceDown nil | boolean @Defaults to true
---@field includeNonCards nil | boolean @Defaults to false
---@field splitDecks nil | boolean @Defaults to true
---@field combineIntoDecks nil | boolean @Defaults to false
---@field combineCardsPerDeck nil | number @Defaults to 0
---@field direction tts__LayoutZone_Direction @Defaults to 0 (Right/Down)
---@field facing nil | tts__LayoutZone_Facing @Defaults to 1 (Become Face Up)
---@field paddingHorizontal nil | number @Defaults to 1
---@field paddingVertical nil | number @Defaults to 1
---@field stickyCards nil | boolean @Defaults to false
---@field instantRefill nil | boolean @Defaults to false
---@field randomize nil | boolean @Defaults to false
---@field manualOnly nil | boolean @Defaults to false
---@field groupDirection nil | tts__LayoutZone_GroupDirection @Defaults to 0 (Eastward)
---@field groupSort nil | tts__LayoutZone_GroupSort @Defaults to 3 (Name)
---@field groupSortReverse nil | boolean @Defaults to false
---@field groupSortExisting nil | boolean @Defaults to false
---@field spreadHorizontal nil | number @Defaults to 0.6
---@field spreadVertical nil | number @Defaults to 0
---@field maxObjectsPerGroup nil | number @Defaults to 13
---@field alternateDirection nil | boolean @Defaults to false
---@field maxObjectsPerNewGroup nil | number @Defaults to 0
---@field allowSwapping nil | boolean @Defaults to false