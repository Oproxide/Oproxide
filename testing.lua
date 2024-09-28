local MyLib = {}

-- Helper function to loop through players and apply a callback to their characters
local function processPlayerCharacters(players, callback)
    for _, player in pairs(players) do
        if player.Character then
            callback(player, player.Character)
        end
    end
end

-- 1. Get all players except the local player and apply a callback to their characters
function MyLib.GetOtherPlayers(localPlayer, callback)
    local players = game:GetService("Players"):GetPlayers()
    
    for _, player in pairs(players) do
        if player ~= localPlayer and player.Character then
            callback(player, player.Character)
        end
    end
end

-- 2. Get all players including the local player and apply a callback to their characters
function MyLib.GetAllPlayers(callback)
    local players = game:GetService("Players"):GetPlayers()
    processPlayerCharacters(players, callback)
end

-- 3. Change all children of `game` to their class names
function MyLib.RenameGameChildrenToClassName()
    local gameChildren = game:GetChildren()
    for _, child in ipairs(gameChildren) do
        local className = child.ClassName
        child.Name = className
    end
end

return MyLib
