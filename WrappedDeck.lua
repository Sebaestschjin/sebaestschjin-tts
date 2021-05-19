local Object = require("sebaestschjin-tts.Object")

---@class seb_WrappedDeck

---@class seb_WrappedDeck_static : seb_WrappedDeck
---@overload fun(deck: tts__Deck): seb_WrappedDeck
---@overload fun(card: tts__Card): seb_WrappedDeck
---@overload fun(card: tts__Vector): seb_WrappedDeck
local WrappedDeck = {}

setmetatable(WrappedDeck, {
    __call = function(_, obj)
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
        ---@type nil | string
        local lastName

        ---@return tts__Deck
        local function asDeck()
            return --[[---@type tts__Deck]] wrappedObject
        end

        ---@return tts__Card
        local function asCard()
            return --[[---@type tts__Card]] wrappedObject
        end

        ---@param card tts__Card
        local function makeCard(card)
            wrappedObject = card
            isDeck = false
            isCard = true
        end

        ---@param deck tts__Deck
        local function makeDeck(deck)
            if deck.remainder then
                -- we have a deck, but it going to be a single card soon
                makeCard(--[[---@type tts__Card]] deck.remainder)
            else
                wrappedObject = deck
                isDeck = true
                isCard = false
                if lastName then
                    deck.setName(--[[---@not nil]] lastName)
                end
            end
        end

        ---@param position tts__Vector
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
            if (--[[---@type tts__Object]] obj).type == Object.Type.Deck then
                makeDeck(--[[---@type tts__Deck]] obj)
            elseif (--[[---@type tts__Object]] obj).type == Object.Type.Card then
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
                        if hitObject.type == Object.Type.Deck then
                            makeDeck(--[[---@type tts__Deck]] hitObject)
                            return
                        elseif hitObject.type == Object.Type.Card then
                            makeCard(--[[---@type tts__Card]] hitObject)
                            return
                        end
                    end
                end
                makeEmpty(--[[---@type tts__Vector]] obj, { 0, 180, 0 })
            end
        end

        ---@type tts__ObjectType
        self.tag = Object.Type.Deck

        ---@return nil | tts__Card | tts__Deck
        function self.unwrap()
            return wrappedObject
        end

        function self.isEmpty()
            return not isDeck and not isCard
        end

        ---@return string
        function self.getName()
            if isDeck then
                return asDeck().getName()
            end
            return lastName or ""
        end

        ---@param name string
        function self.setName(name)
            if isDeck then
                asDeck().setName(name)
            else
                lastName = name
            end
        end

        ---@return tts__ObjectState[]
        function self.getObjects()
            if isDeck then
                return asDeck().getData().ContainedObjects
            elseif isCard then
                return { asCard().getData() }
            else
                return --[[---@type tts__ObjectState[] ]] {}
            end
        end

        ---@param parameters tts__Object_GuidTakeObjectParameters | tts__Object_IndexTakeObjectParameters
        ---@return nil | tts__Object
        function self.takeObject(parameters)
            if isDeck then
                local deckName = asDeck().getName()
                local result = asDeck().takeObject(parameters)
                if (--[[---@type tts__Deck]] wrappedObject).remainder then
                    makeCard(--[[---@type tts__Card]] asDeck().remainder)
                    lastName = deckName
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

        ---@param cardOrDeck tts__Card | tts__Deck
        ---@return tts__Deck
        function self.putObject(cardOrDeck)
            if isDeck then
                return asDeck().putObject(cardOrDeck)
            elseif isCard then
                --[[---@type tts__Deck]]
                local formedDeck
                if Object.isCard(cardOrDeck) then
                    formedDeck = asCard().putObject(--[[---@type tts__Card]] cardOrDeck)
                else
                    formedDeck = (--[[---@type tts__Deck]] cardOrDeck).putObject(asCard())
                end
                makeDeck(formedDeck)
                return formedDeck
            else
                cardOrDeck.setPosition(--[[---@not nil]] lastPosition)
                cardOrDeck.setRotation(--[[---@not nil]] lastRotation)
                if Object.isCard(cardOrDeck) then
                    makeCard(--[[---@type tts__Card]] cardOrDeck)
                else
                    makeDeck(--[[---@type tts__Deck]] cardOrDeck)
                end
            end
        end

        ---@return tts__Vector
        function self.getPosition()
            if isDeck or isCard then
                local position = (--[[---@not nil]] wrappedObject).getPosition()
                return position
            end
            return --[[---@not nil]] lastPosition
        end

        ---@return tts__Vector
        function self.getRotation()
            if isDeck or isCard then
                local rotation = (--[[---@not nil]] wrappedObject).getRotation()
                return rotation
            end
            return --[[---@not nil]] lastRotation
        end

        ---@param rotation tts__VectorShape
        function self.setRotation(rotation)
            if isDeck or isCard then
                (--[[---@not nil]] wrappedObject).setRotation(rotation)
            else
                lastRotation = Vector(rotation)
            end
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

        function self.shuffle()
            if isDeck then
                asDeck().shuffle()
            end
        end

        initialize()

        return self
    end
})

return WrappedDeck