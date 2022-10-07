local Json = require('ge_tts.Json')
local Object = require('sebaestschjin-tts.Object')
local TableUtil = require('sebaestschjin-tts.TableUtil')

local ObjectState = {}

---@type number
local currentDeckId = 0

---@class __ObjectState_this
local this = {}

---@return number
local function nextDeckId()
  currentDeckId = currentDeckId + 1
  return currentDeckId
end

---@param value nil | boolean
---@param default boolean
---@return boolean
local function bool(value, default)
  if value == nil then
    return default
  end
  return --[[---@not nil]] value
end

---@param objectType string
---@param object seb_CustomObject
---@param transform nil | seb_Transform
---@return tts__ObjectState
function ObjectState.object(objectType, object, transform)
  ---@type string | nil
  local scriptState
  if object.state ~= nil then
    if type(object.state) == "string" then
      scriptState = --[[---@type string]] object.state
    else
      scriptState = Json.encode(--[[---@type table]] object.state)
    end
  end

  return {
    Name = objectType,
    Nickname = object.name,
    Description = object.description,
    Locked = object.locked,
    Grid = object.snapToGrid,
    Transform = ObjectState.transform(transform),
    ColorDiffuse = ObjectState.color(object.tint),
    LuaScript = object.script,
    LuaScriptState = scriptState,
    Tags = object.tags,
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

  if deck.deck then
    local deckId = nextDeckId()
    deckState.CustomDeck = {
      [deckId] = {
        FaceURL = (--[[---@not nil]] deck.deck).image,
        BackURL = (--[[---@not nil]] deck.deck).imageBack,
        NumWidth = (--[[---@not nil]] deck.deck).width,
        NumHeight = (--[[---@not nil]] deck.deck).height,
        BackIsHidden = (--[[---@not nil]] deck.deck).backIsHidden,
        UniqueBack = false,
      }
    }

    for i = 1, (--[[---@not nil]] deck.deck).number do
      local cardId = --[[---@not nil]] tonumber(string.format("%d%02d", deckId, i - 1))
      table.insert(deckState.ContainedObjects, {
        Name = Object.Name.Card,
        CardID = cardId,
        CustomDeck = deckState.CustomDeck,
        Transform = ObjectState.transform(transform),
      })
      table.insert(deckState.DeckIDs, cardId)
    end
  end

  if deck.cards then
    for _, card in ipairs(--[[---@not nil]] deck.cards) do
      table.insert(deckState.ContainedObjects, card)
      table.insert(deckState.DeckIDs, card.CardID)
      for id, customDeck in pairs(card.CustomDeck) do
        deckState.CustomDeck[id] = customDeck
      end
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

---@overload fun(model: seb_CustomObject_Model): tts__ModelCustomState
---@param model seb_CustomObject_Model
---@param transform seb_Transform
---@return tts__ModelCustomState
function ObjectState.model(model, transform)
  local name = Object.Name.Model
  if model.type == Object.ModelType.Bag or model.type == Object.ModelType.Infinite then
    name = Object.Name.ModelBag
  end

  local modelState = --[[---@type tts__ModelCustomState]] ObjectState.object(name, model, transform)

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

---@overload fun(token: seb_CustomObject_Tile): tts__TileState
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
      Stretch = bool(tile.stretch, true),
    }
  }

  return tokenState
end

---@overload fun(zone: seb_CustomObject_LayoutZone): tts__LayoutZoneState
---@param zone seb_CustomObject_LayoutZone
---@param transform seb_Transform
---@return tts__LayoutZoneState
function ObjectState.layoutZone(zone, transform)
  local layoutZoneState = --[[---@type tts__LayoutZoneState]] ObjectState.object(Object.Name.LayoutZone, zone, transform)

  layoutZoneState.LayoutZone = {
    Options = {
      TriggerForFaceUp = bool(zone.includeFaceUp, true),
      TriggerForFaceDown = bool(zone.includeFaceDown, true),
      TriggerForNonCards = bool(zone.includeNonCards, false),
      SplitAddedDecks = bool(zone.splitDecks, true),
      CombineIntoDecks = bool(zone.combineIntoDecks, false),
      CardsPerDeck = zone.combineCardsPerDeck or 0,
      Direction = zone.direction,
      NewObjectFacing = zone.facing or 1,
      HorizontalGroupPadding = zone.paddingHorizontal or 1,
      VerticalGroupPadding = zone.paddingVertical or 1,
      StickyCards = bool(zone.stickyCards, false),
      InstantRefill = bool(zone.instantRefill, false),
      Randomize = bool(zone.randomize, false),
      ManualOnly = bool(zone.manualOnly, false),
      MeldDirection = zone.groupDirection or 0,
      MeldSort = zone.groupSort or 3,
      MeldReverseSort = bool(zone.groupSortReverse, false),
      MeldSortExisting = bool(zone.groupSortExisting, false),
      HorizonalSpread = zone.spreadHorizontal or 0.6,
      VerticalSpread = zone.spreadVertical or 0,
      MaxObjectsPerGroup = zone.maxObjectsPerGroup or 13,
      AlternateDirection = bool(zone.alternateDirection, false),
      MaxObjectsPerNewGroup = zone.maxObjectsPerNewGroup or 0,
      AllowSwapping = bool(zone.allowSwapping, false),
    }
  }

  return layoutZoneState
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

---@param color nil | tts__ColorShape
---@return tts__CharColorShape
function ObjectState.color(color)
  ---@type tts__CharColorShape
  local colorShape = { r = 1, g = 1, b = 1, a = 1 }

  if not color then
    return colorShape
  end

  colorShape.r = (--[[---@type tts__CharColorShape]] color).r or (--[[---@type tts__NumColorShape]] color)[1]
  colorShape.g = (--[[---@type tts__CharColorShape]] color).g or (--[[---@type tts__NumColorShape]] color)[2]
  colorShape.b = (--[[---@type tts__CharColorShape]] color).b or (--[[---@type tts__NumColorShape]] color)[3]

  if (--[[---@type tts__CharColorShape]] color).a ~= nil then
    colorShape.a = (--[[---@type tts__CharColorShape]] color).a
  elseif #colorShape == 4 then
    colorShape.a = (--[[---@type tts__NumColorShape]] color)[4]
  end

  return colorShape
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

---@param object tts__ObjectState
---@param tag tts__Object_Tag
function ObjectState.addTag(object, tag)
  if not object.Tags then
    object.Tags = { tag }
  elseif not TableUtil.contains(object.Tags, tag) then
    table.insert(--[[---@not nil]] object.Tags, tag)
  end
end

---@param object tts__ObjectState
---@param useGravity boolean
function ObjectState.setUseGravity(object, useGravity)
  if not object.Rigidbody then
    object.Rigidbody = {}
  end
  object.Rigidbody.UseGravity = useGravity
end

---@param object tts__ObjectState
function ObjectState.getStateId(object)
  if not object.States then
    return -1
  end

  for i = 1, TableUtil.length(object.States) + 1 do
    if (--[[---@not nil]] object.States)[i] == nil then
      return i
    end
  end
end

---@param object tts__ObjectState
---@param state integer
---@return tts__ObjectState
function ObjectState.setState(object, state)
  if not object.States or not (--[[---@not nil]] object.States)[state] then
    return object
  end

  local currentObject = TableUtil.copy(object, true)
  local allStates = --[[---@not nil]] currentObject.States

  local newObject = allStates[state]
  newObject.States = {}

  for i = 1, TableUtil.length(allStates) + 1 do
    if allStates[i] == nil then
      (--[[---@not nil]] newObject.States)[i] = currentObject
    elseif i ~= state then
      (--[[---@not nil]] newObject.States)[i] = allStates[i]
    end
  end
  currentObject.States = nil

  return newObject
end

---@shape seb_ObjectState_Search
---@field index nil | integer
---@field guid nil | GUID

---@overload fun(deck: tts__DeckCustomState, search: seb_ObjectState_Search): (nil | tts__CardCustomState)
---@param container tts__BagState
---@param search seb_ObjectState_Search
---@return nil | tts__ObjectState
function ObjectState.takeObject(container, search)
  ---@param contained tts__ObjectState
  local function isObject(contained)
    return search.guid and contained.GUID == search.guid
  end

  --- For some reason the DeckId for the CustomDeck data of a custom card inside a deck doesn't always match the one from its CardId.
  --- So this function replaces the DeckId for the card based on the data from the deck itself and removes the existing CustomDeck data.
  ---@param deck tts__DeckCustomState
  ---@param card tts__CardCustomState
  ---@param index integer
  local function fixDeckId(deck, card, index)
    local currentDeckId, customDeck = next(card.CustomDeck)
    local actualDeckId = this.deckIdFromCardId(deck.DeckIDs[index])
    if actualDeckId ~= currentDeckId then
      card.CustomDeck[actualDeckId] = customDeck
      card.CustomDeck[currentDeckId] = nil
    end
    return actualDeckId
  end

  ---@param deck tts__DeckCustomState
  ---@param card tts__CardCustomState
  ---@param index integer
  local function handleDeckData(deck, card, index)
    local cardDeckId = fixDeckId(deck, card, index)

    table.remove(deck.DeckIDs, index)

    -- if no other card for this deck id exist, remove the information for it
    for _, existing in ipairs(deck.DeckIDs) do
      local existingDeckId = this.deckIdFromCardId(existing)
      if existingDeckId == cardDeckId then
        return
      end
    end
    deck.CustomDeck[cardDeckId] = nil
  end

  for i, contained in ipairs(container.ContainedObjects or {}) do
    if search.index and i == search.index or isObject(contained) then
      table.remove(container.ContainedObjects, i)
      if Object.isDeck(container) then
        handleDeckData(--[[---@type tts__DeckCustomState]] container, --[[---@type tts__CardCustomState]] contained, i)
      end

      return contained
    end
  end

  return nil
end

---@overload fun(deck: tts__DeckCustomState, card: tts__CardCustomState)
---@param container tts__BagState
---@param object tts__ObjectState
function ObjectState.putObject(container, object)
  if not container.ContainedObjects then
    container.ContainedObjects = {}
  end

  table.insert(container.ContainedObjects, object)

  if Object.isDeck(container) then
    local deck = --[[---@type tts__DeckCustomState]] container
    local card = --[[---@type tts__CardCustomState]] object
    local cardId = card.CardID

    local deckId, customDeck = next(card.CustomDeck)
    deck.CustomDeck[deckId] = customDeck
    table.insert(deck.DeckIDs, cardId)
  end
end

---@param cardId integer
---@return integer
function this.deckIdFromCardId(cardId)
  return tonumber(tostring(cardId):sub(1,-3))
end

return ObjectState
