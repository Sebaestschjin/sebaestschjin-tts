local Math = {}

---@overload fun(value: number): number
---@param value number
---@param decimalPlaces number
---@return number
function Math.round(value, decimalPlaces)
    if decimalPlaces and decimalPlaces > 0 then
        local multiple = 10 ^ decimalPlaces
        return math.floor(value * multiple + 0.5) / multiple
    end

    return math.floor(value + 0.5)
end

return Math