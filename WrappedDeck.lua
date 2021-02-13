local Object = require("sebaestschjin-tts.Object")

---@class seb_WrappedDeck

---@class seb_WrappedDeck_static : seb_WrappedDeck
---@overload fun(deck: tts__Deck): seb_WrappedDeck
---@overload fun(card: tts__Card): seb_WrappedDeck
---@overload fun(card: tts__VectorShape): seb_WrappedDeck
local WrappedDeck = {}

setmetatable(WrappedDeck, {
    __call = function(obj)
        local self = --[[---@type seb_WrappedDeck]] {}

        ---@type nil | tts__Deck | tts__Card
        local wrappedObject
        ---@type boolean
        local isDeck = false
        ---@type boolean
        local isCard = false
        ---@type nil | tts__Vector
        local lastPosition
        ---@type nil | tts__Vector
        local lastRotation

        ---@return tts__Deck
        local function asDeck()
            return --[[---@type tts__Deck]] wrappedObject
        end

        ---@return tts__Card
        local function asCard()
            return --[[---@type tts__Card]] wrappedObject
        end

        ---@param deck tts__Deck
        local function makeDeck(deck)
            wrappedObject = deck
            isDeck = true
            isCard = false
        end

        ---@param card tts__Card
        local function makeCard(card)
            wrappedObject = card
            isDeck = false
            isCard = true
        end

        ---@param position tts__VectorShape
        ---@param rotation tts__VectorShape
        local function makeEmpty(position, rotation)
            wrappedObject = nil
            isDeck = false
            isCard = false
            lastPosition = Vector(position)
            lastRotation = Vector(rotation)
        end

        ---@param card tts__Card
        ---@param parameters tts__Object_GuidTakeObjectParameters | tts__Object_IndexTakeObjectParameters
        local function takeObjectSingle(card, parameters)
            local parametersGuid = (--[[---@type tts__Object_GuidTakeObjectParameters]] parameters).guid
            if parametersGuid and card.getGUID() ~= parametersGuid then
                error("Deck doesn't contain guid " .. parametersGuid)
            end

            if parameters.position then
                if parameters.smooth then
                    card.setPositionSmooth(--[[---@type tts__VectorShape]] parameters.position)
                else
                    card.setPosition(--[[---@type tts__VectorShape]] parameters.position)
                end
            end

            if parameters.rotation then
                card.setRotation(--[[---@type tts__VectorShape]] parameters.rotation)
            elseif parameters.flip then
                card.setRotation(card.getRotation() * Vector(1, -1, 1))
            end

            if parameters.callback_function then
                parameters.callback_function(card)
            end
        end

        local function initialize()
            if (--[[---@type tts__Object]] obj).tag == Object.Tag.Deck then
                if obj.remainder then
                    makeCard(--[[---@type tts__Card]] obj)
                else
                    makeDeck(--[[---@type tts__Deck]] obj)
                end
            elseif (--[[---@type tts__Object]] obj).tag == Object.Tag.Card then
                makeCard(--[[---@type tts__Card]] obj)
            else
                local hit = Physics.cast({
                    origin = obj + Vector(0, 3, 0),
                    direction = { 0, -1, 0 },
                    type = 1,
                })

                if hit then
                    for _, hitInfo in pairs(hit) do
                        local hitObject = hitInfo.hit_object
                        if hitObject.tag == Object.Tag.Deck then
                            makeDeck(--[[---@type tts__Deck]] hitObject)
                            return
                        elseif hitObject.tag == Object.Tag.Card then
                            makeCard(--[[---@type tts__Card]] hitObject)
                            return
                        end
                    end
                end
                makeEmpty(--[[---@type tts__VectorShape]] obj, { 0, 180, 0 })
            end
        end

        ---@type tts__ObjectType
        self.tag = Object.Tag.Deck

        ---@return tts__IndexedSimpleObjectState[]
        function self.getObjects()
            if isDeck then
                return asDeck().getObjects()
            elseif isCard then
                local card = asCard()
                return { {
                             name = card.getName(),
                             nickname = card.getName(),
                             description = card.getDescription(),
                             gm_notes = card.getGMNotes(),
                             guid = card.getGUID(),
                             lua_script = card.script_code,
                             lua_script_state = card.script_state,
                             index = 1,
                         } }
            else
                return --[[---@type tts__IndexedSimpleObjectState[] ]] {}
            end
        end

        ---@return seb_WrappedContainedObject_old[]
        function self.getContainedObjects()
            if isDeck then
            elseif isCard then
            else
                return {}
            end
        end

        ---@param parameters tts__Object_GuidTakeObjectParameters | tts__Object_IndexTakeObjectParameters
        ---@return nil | tts__Object
        function self.takeObject(parameters)
            if isDeck then
                local result = asDeck().takeObject(parameters)
                if asDeck().remainder then
                    makeCard(--[[---@type tts__Card]] asDeck().remainder)
                end
                return result
            elseif isCard then
                local position = asCard().getPosition()
                local rotation = asCard().getRotation()
                takeObjectSingle(asCard(), parameters)
                makeEmpty(position, rotation)
                return asCard()
            end
        end

        ---@param card tts__Card
        ---@return tts__Deck
        function self.putObject(card)
            if isDeck then
                return asDeck().putObject(card)
            elseif isCard then
                local formedDeck = asCard().putObject(card)
                makeDeck(formedDeck)
                return formedDeck
            else
                card.setPosition(--[[---@not nil]] lastPosition)
                card.setRotation(--[[---@not nil]] lastRotation)
                makeCard(card)
            end
        end

        ---@return tts__Vector
        function self.getPosition()
            if isDeck or isCard then
                (--[[---@not nil]] wrappedObject).getPosition()
            end
            return --[[---@not nil]] lastPosition
        end

        ---@return tts__Vector
        function self.getRotation()
            if isDeck or isCard then
                (--[[---@not nil]] wrappedObject).getRotation()
            end
            return --[[---@not nil]] lastRotation
        end

        ---@return tts__DeckState
        function self.getData()
            if isDeck then
                return --[[---@type tts__DeckState]] asDeck().getData()
            elseif isCard then
                local cardData = --[[---@type tts__DeckState]] asCard().getData()
                cardData.ContainedObjects = { cardData }
                return cardData
            else
                return --[[---@type tts__DeckState]] {
                    ContainedObjects = {}
                }
            end
        end

        initialize()

        return self
    end
})

return WrappedDeck