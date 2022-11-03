local Math = {}

--- Same as Math.roundUp()
---@overload fun(value: number): number
---@param value number
---@param decimalPlaces number @Defaults to 0.
---@return number
function Math.round(value, decimalPlaces)
    return Math.roundUp(value, decimalPlaces)
end

---@overload fun(value: number): number
---@param value number
---@param decimalPlaces number @Defaults to 0.
---@return number
function Math.roundUp(value, decimalPlaces)
    if decimalPlaces and decimalPlaces > 0 then
        local multiple = 10 ^ decimalPlaces
        return math.floor(value * multiple + 0.5) / multiple
    end

    return math.floor(value + 0.5)
end

---@overload fun(value: number): number
---@param value number
---@param decimalPlaces number @Defaults to 0.
---@return number
function Math.roundDown(value, decimalPlaces)
    if decimalPlaces and decimalPlaces > 0 then
        local multiple = 10 ^ decimalPlaces
        return math.ceil(value * multiple + 0.5) / multiple
    end

    return math.ceil(value - 0.5)
end

---@param value number
---@param min number
---@param max number
function Math.clamp(value, min, max)
  if value < min then
    return min
  end

  if value > max then
    return max
  end

  return value
end

return Math
