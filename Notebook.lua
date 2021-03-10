--- Helper methods to access to player notebooks within TTS.
local Notebook = {}

---@return tts__Notes_GetParameter[]
function Notebook.getAll()
    return Notes.getNotebookTabs()
end

--- Returns the content of the first notebook with the given title.
---@param title string
---@return nil | string
function Notebook.getContent(title)
    for _, notebook in pairs(Notes.getNotebookTabs()) do
        if notebook.title == title then
            return notebook.body
        end
    end
    return nil
end

--- Sets the content of a notebook with the given name. If no such notebook can be found a new one will be created.
--- If the player color is given the existing or new notebook will be only readable by this player.
---@overload fun(name: string, content: string): void
---@param title string
---@param content string
---@param player tts__PlayerColor
function Notebook.setContent(title, content, player)
    for _, notebook in pairs(Notes.getNotebookTabs()) do
        if notebook.title == title then
            Notes.editNotebookTab({
                index = notebook.index,
                body = content,
                color = player,
            })
            return
        end
    end
    Notebook.addContent(title, content, player)
end

--- Adds a notebook with the given name.
---@overload fun(name: string, content: string): void
---@param title string
---@param content string
---@param player tts__PlayerColor
function Notebook.addContent(title, content, player)
    Notes.addNotebookTab({
        title = title,
        body = content,
        color = player,
    })
end

return Notebook