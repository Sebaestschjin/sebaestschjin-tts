local Object = require('sebaestschjin-tts.Object')

---@type number
local currentDeckId = 0

---@return number
local function nextDeckId()
    currentDeckId = currentDeckId + 1
    return currentDeckId
end

local ObjectState = {}

---@param type string
---@param object seb_CustomObject
---@param transform nil | seb_Transform
---@return tts__ObjectState
function ObjectState.object(type, object, transform)
    return {
        Name = type,
        Nickname = object.name,
        Description = object.description,
        Locked = object.locked,
        Grid = object.snapToGrid,
        Transform = ObjectState.transform(transform),
    }
end

---@overload fun(bag: seb_CustomObject_Bag): tts__BagState
---@param bag seb_CustomObject_Bag
---@param transform seb_Transform
---@return tts__BagState
function ObjectState.bag(bag, transform)
    local bagState = --[[---@type tts__BagState]] ObjectState.object(Object.Name.Bag, bag, transform)

    bagState.ContainedObjects = bag.objects or {}

    return bagState
end

---@overload fun(deck: seb_CustomObject_DeckCustom): tts__DeckCustomState
---@param deck seb_CustomObject_DeckCustom
---@return tts__DeckCustomState
function ObjectState.deckCustom(deck, transform)
    local deckState = --[[---@type tts__DeckCustomState]] ObjectState.object(Object.Name.Deck, deck, transform)

    deckState.DeckIDs = {}
    deckState.ContainedObjects = {}
    deckState.CustomDeck = {}

    for _, card in ipairs(deck.cards) do
        table.insert(deckState.ContainedObjects, card)
        table.insert(deckState.DeckIDs, card.CardID)
        for id, customDeck in pairs(card.CustomDeck) do
            deckState.CustomDeck[id] = customDeck
        end
    end

    return deckState
end

---@overload fun(card: seb_CustomObject_CardCustom): tts__CardCustomState
---@param card seb_CustomObject_CardCustom
---@param transform seb_Transform
---@return tts__CardCustomState
function ObjectState.cardCustom(card, transform)
    local cardState = --[[---@type tts__CardCustomState]] ObjectState.object(Object.Name.Card, card, transform)

    local deckId = nextDeckId()
    cardState.CardID = deckId * 100
    cardState.CustomDeck = {
        [deckId] = {
            FaceURL = card.image,
            BackURL = card.imageBack or card.image,
            NumWidth = 1,
            NumHeight = 1,
            BackIsHidden = true,
            UniqueBack = false,
        }
    }

    return cardState
end

---@param model seb_CustomObject_Model
---@param transform seb_Transform
---@return tts__ModelCustomState
function ObjectState.model(model, transform)
    local modelState = --[[---@type tts__ModelCustomState]] ObjectState.object(Object.Name.Model, model, transform)

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

---@overload fun(token: seb_CustomObject_Token): tts__TokenState
---@param token seb_CustomObject_Token
---@param transform seb_Transform
---@return tts__TokenState
function ObjectState.token(token, transform)
    local tokenState = --[[---@type tts__TokenState]] ObjectState.object(Object.Name.Token, token, transform)

    tokenState.CustomImage = {
        ImageURL = token.image,
        CustomToken = {
            Stackable = token.stackable,
            MergeDistancePixels = token.mergeDistance or 15,
            Thickness = token.thickness or 0.2
        }
    }

    return tokenState
end

---@overload fun(token: seb_CustomObject_Token): tts__TileState
---@param tile seb_CustomObject_Tile
---@param transform seb_Transform
---@return tts__TileState
function ObjectState.tile(tile, transform)
    local tokenState = --[[---@type tts__TileState]] ObjectState.object(Object.Name.Tile, tile, transform)

    tokenState.CustomImage = {
        ImageURL = tile.image,
        ImageSecondaryURL = tile.imageBottom,
        CustomTile = {
            Type = tile.type or Object.TileType.Box,
            Stackable = tile.stackable,
            Thickness = tile.thickness or 0.5,
            Stretch = tile.stretch or true,
        }
    }

    return tokenState
end

--- Taken from ge_tts.ObjectUtils, but I don't want to always have the onObjectSpawn event registered.
---@param transform nil | seb_Transform
---@return tts__ObjectState_Transform
function ObjectState.transform(transform)
    ---@type tts__ObjectState_Transform
    local state = {}

    if not transform then
        transform = {}
    end

    ---@type nil | tts__VectorShape
    local position = (--[[---@not nil]] transform).position
    if not position then
        position = { 0, 3, 0 }
    end
    state.posX = (--[[---@type tts__CharVectorShape]] position).x or (--[[---@type tts__NumVectorShape]] position)[1]
    state.posY = (--[[---@type tts__CharVectorShape]] position).y or (--[[---@type tts__NumVectorShape]] position)[2]
    state.posZ = (--[[---@type tts__CharVectorShape]] position).z or (--[[---@type tts__NumVectorShape]] position)[3]

    ---@type nil | tts__VectorShape
    local rotation = (--[[---@not nil]] transform).rotation
    if not rotation then
        rotation = { 0, 180, 0 }
    end
    state.rotX = (--[[---@type tts__CharVectorShape]] rotation).x or (--[[---@type tts__NumVectorShape]] rotation)[1]
    state.rotY = (--[[---@type tts__CharVectorShape]] rotation).y or (--[[---@type tts__NumVectorShape]] rotation)[2]
    state.rotZ = (--[[---@type tts__CharVectorShape]] rotation).z or (--[[---@type tts__NumVectorShape]] rotation)[3]

    ---@type nil | tts__VectorShape
    local scale = (--[[---@not nil]] transform).scale
    if not scale then
        scale = { 1, 1, 1 }
    end
    state.scaleX = (--[[---@type tts__CharVectorShape]] scale).x or (--[[---@type tts__NumVectorShape]] scale)[1]
    state.scaleY = (--[[---@type tts__CharVectorShape]] scale).y or (--[[---@type tts__NumVectorShape]] scale)[2]
    state.scaleZ = (--[[---@type tts__CharVectorShape]] scale).z or (--[[---@type tts__NumVectorShape]] scale)[3]

    return state
end

---@param object tts__ObjectState
---@param decal tts__Object_DecalParameters
function ObjectState.addDecal(object, decal)
    local attached = object.AttachedDecals
    if not attached then
        attached = --[[---@type tts__ObjectState_Decal[] ]]{}
        object.AttachedDecals = attached
    end

    ---@type tts__ObjectState_Decal
    local decalData = {
        Transform = ObjectState.transform({
            position = decal.position,
            rotation = decal.rotation,
            scale = decal.scale,
        }),
        CustomDecal = {
            Name = decal.name,
            ImageURL = decal.url,
        }
    }
    table.insert(--[[---@not nil]] attached, decalData)
end

return ObjectState
