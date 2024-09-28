local MyLib = {}

-- Helper function to loop through players and apply a callback to their entire player model
local function processPlayerObjects(players, localPlayer, includeLocalPlayer, callback)
    for _, player in pairs(players) do
        if includeLocalPlayer or player ~= localPlayer then
            callback(player)
        end
    end
end

-- Combined function to get all players or just other players and apply a callback
function MyLib.GetPlayers(option, localPlayer, callback)
    local players = game:GetService("Players"):GetPlayers()
    
    -- Check the option to determine whether to include the local player
    if option == "all" then
        processPlayerObjects(players, localPlayer, true, callback)
    elseif option == "others" then
        processPlayerObjects(players, localPlayer, false, callback)
    else
        warn("Invalid option: Please specify 'all' or 'others'")
    end
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
