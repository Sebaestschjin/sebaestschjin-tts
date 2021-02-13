local Object = require('sebaestschjin-tts.Object')

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

---@param objectState tts__ObjectState
---@return boolean
function ObjectState.isCard(objectState)
    local type = Object.TypeForName[objectState.Name]
    return type == Object.Type.Card
end

---@param objectState tts__ObjectState
---@return boolean
function ObjectState.isContainer(objectState)
    local type = Object.TypeForName[objectState.Name]
    return type == Object.Type.Bag or type == Object.Type.Deck
end

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
        Transform = ObjectState.transformState({
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

--- Taken from ge_tts.ObjectUtils, but I don't want to always have the onObjectSpawn event registered.
function ObjectState.transformState(transform)
    ---@type tts__ObjectState_Transform
    local state = {}

    ---@type nil | tts__VectorShape
    local position = transform.position
    ---@type nil | tts__VectorShape
    local rotation = transform.rotation
    ---@type nil | tts__VectorShape
    local scale = transform.scale

    if position then
        state.posX = (--[[---@type tts__CharVectorShape]] position).x or (--[[---@type tts__NumVectorShape]] position)[1]
        state.posY = (--[[---@type tts__CharVectorShape]] position).y or (--[[---@type tts__NumVectorShape]] position)[2]
        state.posZ = (--[[---@type tts__CharVectorShape]] position).z or (--[[---@type tts__NumVectorShape]] position)[3]
    end

    if rotation then
        state.rotX = (--[[---@type tts__CharVectorShape]] rotation).x or (--[[---@type tts__NumVectorShape]] rotation)[1]
        state.rotY = (--[[---@type tts__CharVectorShape]] rotation).y or (--[[---@type tts__NumVectorShape]] rotation)[2]
        state.rotZ = (--[[---@type tts__CharVectorShape]] rotation).z or (--[[---@type tts__NumVectorShape]] rotation)[3]
    end

    if scale then
        state.scaleX = (--[[---@type tts__CharVectorShape]] scale).x or (--[[---@type tts__NumVectorShape]] scale)[1]
        state.scaleY = (--[[---@type tts__CharVectorShape]] scale).y or (--[[---@type tts__NumVectorShape]] scale)[2]
        state.scaleZ = (--[[---@type tts__CharVectorShape]] scale).z or (--[[---@type tts__NumVectorShape]] scale)[3]
    end

    return state
end

---@param object tts__ObjectState
---@param decal tts__Object_DecalParameters
function ObjectState.addDecal(object, decal)
    local attached = object.AttachedDecals
    if not attached then
        attached = {}
        object.AttachedDecals = attached
    end

    local decalData = {
        Transform = ObjectState.transformState({
            position = decal.position,
            rotation = decal.rotation,
            scale = decal.scale,
        }),
        CustomDecal = {
            Name = decal.name,
            ImageURL = decal.url,
        }
    }
    table.insert(attached, decalData)
end

---@param transform tts__ObjectState_Transform
---@return tts__Vector
function ObjectState.transformToPosition(transform)
    return Vector(--[[---@not nil]] transform.posX, --[[---@not nil]] transform.posY, --[[---@not nil]] transform.posZ)
end

---@param transform tts__ObjectState_Transform
---@return tts__Vector
function ObjectState.transformToRotation(transform)
    return Vector(--[[---@not nil]] transform.rotX, --[[---@not nil]] transform.rotY, --[[---@not nil]] transform.rotZ)
end

---@param transform tts__ObjectState_Transform
---@return tts__Vector
function ObjectState.transformToScale(transform)
    return Vector(--[[---@not nil]] transform.scaleX, --[[---@not nil]] transform.scaleY, --[[---@not nil]] transform.scaleZ)
end

return ObjectState
