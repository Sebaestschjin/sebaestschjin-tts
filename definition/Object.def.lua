
---@alias seb_ObjectLike tts__Object | seb_WrappedObject
---@alias seb_DecalLike tts__Object_Decal | seb_WrappedDecal

---@alias seb_ObjectLike_old tts__Object | seb_WrappedObject_old | seb_WrappedContainedObject_old
---@alias seb_ObjectLikeArray tts__Object[] | seb_WrappedObject_old[] | seb_WrappedContainedObject_old[]
---@alias seb_ContainerLike tts__Container | common_DeckZone

---@alias seb_DecalLike_old tts__Object_Decal | seb_WrappedDecal_old
---@alias seb_DecalsLike_old tts__Object_Decal[] | seb_WrappedDecal_old[]

--- A wrapper around an objects data to work with it like a regular Object.
--- Only a few functions/attributes are currently really present (as needed).
---@shape seb_WrappedObject_old
---@field tag string
---@field getData fun(): tts__ObjectState
---@field getDescription fun(): string
---@field getDecals fun(): seb_WrappedDecal_old[]
---@field getGUID fun(): GUID
---@field getName fun(): string
---@field getPosition fun(): tts__VectorShape

---@shape seb_WrappedDecal_old
---@field name string
---@field position tts__VectorShape

---@shape seb_WrappedContainedObject_old : seb_WrappedObject_old
---@field index number
