local Object = require('ge_tts.Object')
local ObjectUtils = require('ge_tts.ObjectUtils')

---@shape se_tts__ObjectInfo
---@field name nil | string
---@field description nil | string
---@field locked nil | boolean @Default false
---@field snapToGrid nil | boolean @Default true
---@field tint nil | tts__ColorShape

---@shape se_tts__CardInfo : se_tts__ObjectInfo
---@field imageUrl string
---@field backImageUrl string

---@shape se_tts__ModelInfo : se_tts__ObjectInfo
---@field mesh string
---@field diffuse nil | string
---@field collider nil | string
---@field type nil | tts__ModelType
---@field material nil | tts__MaterialType

---@type number
local currentDeckId = 0

---@return number
local function nextDeckId()
    currentDeckId = currentDeckId + 1
    return currentDeckId
end

local ObjectState = {}

---@param object se_tts__ObjectInfo
---@param position tts__VectorShape
---@return tts__ObjectState
function ObjectState.objectState(object, position, type)
    return {
        Name = type,
        Nickname = object.name,
        Description = object.description,
        Locked = object.locked,
        Grid = object.snapToGrid,
        ColorDiffuse = object.tint,
        Transform = ObjectUtils.transformState({
            position = position,
            rotation = { 0, 0, 0 },
            scale = { 1, 1, 1 },
        }),
    }
end

---@param card se_tts__CardInfo
---@param position tts__VectorShape
---@return tts__CardCustomState
function ObjectState.cardState(card, position)
    local cardState = --[[---@type tts__CardCustomState]] ObjectState.objectState(card, position, Object.Name.Card)

    local deckId = nextDeckId()
    cardState.CardID = deckId * 100
    cardState.CustomDeck = {
        [tostring(deckId)] = {
            FaceURL = card.imageUrl,
            BackURL = card.backImageUrl,
            NumWidth = 1,
            NumHeight = 1,
            BackIsHidden = true,
            UniqueBack = false,
        }
    }

    return cardState
end

---@param model se_tts__ModelInfo
---@param position tts__VectorShape
---@return tts__ModelCustomState
function ObjectState.modelState(model, position)
    local modelState = --[[---@type tts__ModelCustomState]] ObjectState.objectState(model, position, Object.Name.Model)

    modelState.CustomMesh = {
        MeshURL = model.mesh,
        DiffuseURL = model.diffuse,
        ColliderURL = model.collider,
        Convex = true,
        MaterialIndex = model.material,
        TypeIndex = model.type,
        CastShadow = true,
    }

    return modelState
end

return ObjectState