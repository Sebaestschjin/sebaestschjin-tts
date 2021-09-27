local Object = require("sebaestschjin-tts.Object")
local StringUtil = require("sebaestschjin-tts.StringUtil")
local TableUtil = require("sebaestschjin-tts.TableUtil")

local Search = {}

---@shape seb_Search
---@field guid nil | GUID
---@field name nil | string
---@field description nil | string
---@field memo nil | string
---@field isPattern nil | boolean

---@shape seb_Search_Full : seb_Search
---@field cardId nil | number
---@field type nil | tts__ObjectType

---@shape seb_Search_Minimal : seb_Search
---@field cardId nil
---@field type nil


---@param searchField nil | string | number
---@param searchValue nil | string | number
---@param isPattern nil | boolean
---@return boolean
local function matches(searchField, searchValue, isPattern)
    local plain = not isPattern
    return searchField == nil or string.find(tostring(searchValue), tostring(searchField), 1, plain) ~= nil
end

--- Finds the first object in all objects that matches the given search.
---@param search seb_Search_Full
---@return nil | tts__Object
function Search.inAllObjects(search)
    for _, contained in ipairs(getObjects()) do
        if matches(search.guid, contained.getGUID(), search.isPattern)
                and matches(search.name, contained.getName(), search.isPattern)
                and matches(search.description, contained.getDescription(), search.isPattern)
                and matches(search.memo, contained.getMemo(), search.isPattern)
                and matches(search.cardId, contained.getData().CardID, search.isPattern)
                and matches(search.type, contained.type, search.isPattern)
        then
            return contained
        end
    end

    return nil
end

--- Finds the first object in the given container that matches the given search.
---@param object tts__Container
---@param search seb_Search_Minimal
---@return nil | tts__IndexedSimpleObjectState
function Search.inContainer(object, search)
    for _, contained in ipairs(object.getObjects()) do
        if matches(search.guid, contained.guid, search.isPattern)
                and matches(search.name, contained.name, search.isPattern)
                and matches(search.description, contained.description, search.isPattern)
                and matches(search.memo, contained.memo, search.isPattern)
        then
            return contained
        end
    end

    return nil
end

--- Finds the first object in the given scripting zone that matches the given search.
---@param zone tts__ScriptingTrigger
---@param search seb_Search_Full
---@return nil | tts__Object
function Search.inZone(zone, search)
    for _, contained in ipairs(zone.getObjects()) do
        if matches(search.guid, contained.getGUID(), search.isPattern)
                and matches(search.name, contained.getName(), search.isPattern)
                and matches(search.description, contained.getDescription(), search.isPattern)
                and matches(search.memo, contained.getMemo(), search.isPattern)
                and matches(search.cardId, contained.getData().CardID, search.isPattern)
                and matches(search.type, contained.type, search.isPattern)
        then
            return contained
        end
    end

    return nil
end

--- Finds the first object in the given container that matches the given search. Unlike Search.inContainer this search
--- uses the internal representation of the container objects and thus can use more fields for searching. The returned
--- object state also contains a lot more information
--- Note: The returned index starts with 0! This was done to have the same behaviour as the index attribute in
--- tts__IndexedSimpleObjectState.
---@param object tts__Container | seb_WrappedDeck
---@param search seb_Search_Full
---@return nil | (tts__ObjectState, number)
function Search.inContainedObjects(object, search)
    for i, contained in TableUtil.ipairs(object.getData().ContainedObjects) do
        if matches(search.guid, contained.GUID, search.isPattern)
                and matches(search.name, contained.Nickname, search.isPattern)
                and matches(search.description, contained.Description, search.isPattern)
                and matches(search.memo, contained.Memo, search.isPattern)
                and matches(search.cardId, contained.CardID, search.isPattern)
                and matches(search.type, Object.type(contained), search.isPattern)
        then
            return contained, i - 1
        end
    end

    return nil
end

--- Finds the nearest object in the given container. The nearest object is determined by the Levenshtein distance on the
--- given name. If maxDistance is given only objects with a distance lower than this value are considered.
---@overload fun(container: tts__Container | seb_WrappedDeck, name: string): nil | (tts__ObjectState, number)
---@param container tts__Container | seb_WrappedDeck
---@param name string
---@param maxDistance number
---@return nil | (tts__ObjectState, number)
function Search.nearestInContainedObjects(container, name, maxDistance)
    local nearestDistance, nearestObject

    for _, object in TableUtil.ipairs(container.getData().ContainedObjects) do
        local distance = StringUtil.distance(Object.name(object), name)
        if (not maxDistance or distance <= maxDistance)
                and (not nearestDistance or distance < nearestDistance) then
            nearestDistance = distance
            nearestObject = object
        end
    end

    return nearestObject, nearestDistance
end

return Search
