local Search = {}

---@shape seb_Search
---@field guid nil | GUID
---@field name nil | string

---@param objects tts__Object[]
---@param search seb_Search
---@return nil | (tts__Object, number)
function Search.findInObjects(objects, search)
    for i, contained in ipairs(objects) do
        if (search.guid == nil or contained.getGUID() == search.guid)
                and (search.name == nil or contained.getName() == search.name)
        then
            return contained, i
        end
    end

    return nil
end

---@param containedObjects tts__ObjectState[]
---@param search seb_Search
---@return nil | (tts__ObjectState, number)
function Search.findInObjectStates(containedObjects, search)
    for i, contained in ipairs(containedObjects) do
        if (search.guid == nil or contained.GUID == search.guid)
                and (search.name == nil or contained.Nickname == search.name)
        then
            return contained, i
        end
    end

    return nil
end

return Search